# Setup Guide

This guide will help you get started with the Antigravity Nix flake.

## Prerequisites

### Install Nix

If you don't have Nix installed:

**Linux/macOS:**
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

**NixOS:**
Nix is already installed!

### Enable Flakes

Flakes are required for this project. Enable them by adding to `~/.config/nix/nix.conf`:

```
experimental-features = nix-command flakes
```

Or set temporarily:
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Restart your terminal after making changes.

## Installation Methods

### Method 1: Direct Run (No Installation)

Run Antigravity without installing:

```bash
nix run github:USERNAME/REPO -- --help
```

### Method 2: Nix Profile (User Installation)

Install to your user profile:

```bash
nix profile install github:USERNAME/REPO
```

Verify installation:
```bash
antigravity --version
```

Remove if needed:
```bash
nix profile remove antigravity
```

### Method 3: Nix Shell (Temporary)

Create a temporary environment:

```bash
nix shell github:USERNAME/REPO
antigravity --version
```

Exit the shell to remove access.

### Method 4: Flake-based Project

Add to your project's `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    antigravity.url = "github:USERNAME/REPO";
  };

  outputs = { self, nixpkgs, antigravity }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          antigravity.packages.${system}.default
        ];
      };
    };
}
```

Enter the dev shell:
```bash
nix develop
antigravity --version
```

### Method 5: NixOS System Configuration

Add to `/etc/nixos/configuration.nix`:

```nix
{ config, pkgs, ... }:

{
  # Add flake input at the top level
  inputs.antigravity.url = "github:USERNAME/REPO";

  # In your configuration
  environment.systemPackages = [
    inputs.antigravity.packages.${pkgs.system}.default
  ];
}
```

Rebuild your system:
```bash
sudo nixos-rebuild switch
```

### Method 6: Home Manager

Add to your Home Manager configuration:

```nix
{ config, pkgs, ... }:

{
  # Add flake input
  inputs.antigravity.url = "github:USERNAME/REPO";

  # In your home configuration
  home.packages = [
    inputs.antigravity.packages.${pkgs.system}.default
  ];
}
```

Apply changes:
```bash
home-manager switch
```

## Verification

After installation, verify everything works:

```bash
# Check version
antigravity --version

# View help
antigravity --help

# Test basic functionality
antigravity changelog
```

## Updating

### Automatic Updates

The flake automatically checks for updates every 7 days via GitHub Actions.

### Manual Update

Update your installation:

```bash
# For nix profile
nix profile upgrade antigravity

# For flake-based projects
nix flake update antigravity
```

## Troubleshooting

### "Command not found"

Ensure your PATH includes Nix profile binaries:
```bash
export PATH="$HOME/.nix-profile/bin:$PATH"
```

Add to your shell config (`~/.bashrc`, `~/.zshrc`, etc.).

### "Experimental features not enabled"

Enable flakes as described in Prerequisites.

### "Unsupported system"

Currently only Linux x86_64 is supported. Other platforms coming soon.

### Permission Issues

If you encounter permission errors, ensure you have write access to:
- `~/.nix-profile` (for profile installs)
- Your project directory (for flake-based projects)

### Build Failures

Try cleaning the Nix store:
```bash
nix-collect-garbage -d
```

Then retry the installation.

## Next Steps

- Read the [README](../README.md) for usage examples
- Check [CONTRIBUTING](../CONTRIBUTING.md) to contribute
- Report issues on [GitHub](https://github.com/USERNAME/REPO/issues)

## Getting Help

- GitHub Issues: Report bugs or request features
- GitHub Discussions: Ask questions and share ideas
- Documentation: Check other docs in the `docs/` directory
