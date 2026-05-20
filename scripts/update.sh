#!/usr/bin/env bash
#
# Update script for Antigravity flake
# Fetches the latest version and updates flake.nix with new hashes
#

set -euo pipefail

MANIFEST_BASE="https://antigravity-cli-auto-updater-974169037036.us-central1.run.app/manifests"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Platform configurations
declare -A PLATFORMS=(
    ["x86_64-linux"]="linux_amd64"
    ["aarch64-linux"]="linux_arm64"
    ["x86_64-darwin"]="darwin_amd64"
    ["aarch64-darwin"]="darwin_arm64"
)

# Fetch manifest for a platform
fetch_manifest() {
    local platform=$1
    local url="${MANIFEST_BASE}/${platform}.json"
    
    log_info "Fetching manifest for ${platform}..."
    
    if ! curl -fsSL "$url" 2>/dev/null; then
        log_warn "Failed to fetch manifest for ${platform}"
        return 1
    fi
    
    return 0
}

# Convert hex SHA-512 to Nix SRI format
hex_to_sri() {
    local hex=$1
    echo -n "$hex" | xxd -r -p | base64 | tr -d '\n'
    echo ""
}

# Main update logic
main() {
    log_info "Starting Antigravity flake update..."
    
    # Fetch Linux x64 manifest (primary platform)
    local primary_manifest
    primary_manifest=$(fetch_manifest "linux_amd64")
    
    if [ -z "$primary_manifest" ]; then
        log_error "Failed to fetch primary manifest"
        exit 1
    fi
    
    # Parse version and URL
    local version
    version=$(echo "$primary_manifest" | grep -o '"version": *"[^"]*"' | sed 's/"version": *"\([^"]*\)"/\1/')
    
    log_info "Latest version: ${version}"
    
    # Check current version
    local current_version
    current_version=$(grep 'version = ' flake.nix | head -1 | sed 's/.*"\(.*\)".*/\1/')
    
    if [ "$version" = "$current_version" ]; then
        log_info "Already at latest version ${version}"
        exit 0
    fi
    
    log_info "Updating from ${current_version} to ${version}"
    
    # Fetch and convert hashes for all platforms
    declare -A hashes
    
    for nix_platform in "${!PLATFORMS[@]}"; do
        local ag_platform="${PLATFORMS[$nix_platform]}"
        local manifest
        
        manifest=$(fetch_manifest "$ag_platform")
        
        if [ -n "$manifest" ]; then
            local hex_hash
            hex_hash=$(echo "$manifest" | grep -o '"sha512": *"[^"]*"' | sed 's/"sha512": *"\([^"]*\)"/\1/')
            
            if [ -n "$hex_hash" ]; then
                local sri_hash
                sri_hash="sha512-$(hex_to_sri "$hex_hash")"
                hashes[$nix_platform]="$sri_hash"
                log_info "Hash for ${nix_platform}: ${sri_hash:0:20}..."
            else
                log_warn "No hash found for ${nix_platform}"
                hashes[$nix_platform]=""
            fi
        else
            log_warn "Skipping ${nix_platform} (manifest not available)"
            hashes[$nix_platform]=""
        fi
    done
    
    # Update flake.nix
    log_info "Updating flake.nix..."
    
    # Create temporary file
    local temp_file
    temp_file=$(mktemp)
    
    # Read and update flake.nix
    awk -v version="$version" \
        -v hash_x64_linux="${hashes[x86_64-linux]}" \
        -v hash_arm64_linux="${hashes[aarch64-linux]}" \
        -v hash_x64_darwin="${hashes[x86_64-darwin]}" \
        -v hash_arm64_darwin="${hashes[aarch64-darwin]}" '
    /version = ".*";/ && !updated_version {
        print "        version = \"" version "\";";
        updated_version = 1;
        next;
    }
    /"x86_64-linux" = ".*";/ && in_hashes {
        print "          \"x86_64-linux\" = \"" hash_x64_linux "\";";
        next;
    }
    /"aarch64-linux" = ".*";/ && in_hashes {
        print "          \"aarch64-linux\" = \"" hash_arm64_linux "\";";
        next;
    }
    /"x86_64-darwin" = ".*";/ && in_hashes {
        print "          \"x86_64-darwin\" = \"" hash_x64_darwin "\";";
        next;
    }
    /"aarch64-darwin" = ".*";/ && in_hashes {
        print "          \"aarch64-darwin\" = \"" hash_arm64_darwin "\";";
        next;
    }
    /hashes = {/ {
        in_hashes = 1;
    }
    /};/ && in_hashes {
        in_hashes = 0;
    }
    { print }
    ' flake.nix > "$temp_file"
    
    mv "$temp_file" flake.nix
    
    log_info "Update complete!"
    log_info "New version: ${version}"
    
    # Verify the flake
    log_info "Verifying flake..."
    if nix flake check 2>&1 | grep -q "error:"; then
        log_error "Flake check failed. Please review changes."
        exit 1
    fi
    
    log_info "Flake verification successful!"
}

main "$@"
