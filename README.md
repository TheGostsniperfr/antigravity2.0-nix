# Antigravity 2.0 Nix Flake

[![CI](https://github.com/TheGostsniperfr/antigravity2.0-nix/workflows/CI/badge.svg)](https://github.com/TheGostsniperfr/antigravity2.0-nix/actions)
[![Update](https://github.com/TheGostsniperfr/antigravity2.0-nix/workflows/Update%20Antigravity%20Version/badge.svg)](https://github.com/TheGostsniperfr/antigravity2.0-nix/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Nix](https://img.shields.io/badge/Nix-Flakes-blue.svg)](https://nixos.org)

A professional Nix flake for [Antigravity 2.0](https://antigravity.google), Google's next-generation development CLI tool.

> **Production-ready** • **Auto-updating** • **Secure** • **Well-documented**

## Features

- ✨ **Zero-config installation** - Works out of the box with Nix flakes
- 🔄 **Automatic updates** - Weekly checks for new Antigravity releases
- 🔒 **Cryptographic verification** - SHA-512 checksums for all downloads
- 🚀 **Multiple installation methods** - Profile, shell, system-wide, or project-based
- 📦 **Reproducible builds** - Guaranteed consistency across systems
- 🏗️ **Multi-platform ready** - Architecture supports Linux and macOS (x64/ARM64)
- 📚 **Comprehensive docs** - Guides for every use case
- 🤖 **CI/CD integrated** - Automated testing and updates

## Quick Start

### Using `nix run`

Run Antigravity directly without installation:

```bash
nix run github:TheGostsniperfr/antigravity2.0-nix
```

### Using `nix profile`

Install Antigravity to your profile:

```bash
nix profile install github:TheGostsniperfr/antigravity2.0-nix
```

### Using `nix shell`

Create a temporary shell with Antigravity available:

```bash
nix shell github:TheGostsniperfr/antigravity2.0-nix
```

### In a flake-based project

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    antigravity.url = "github:TheGostsniperfr/antigravity2.0-nix";
  };

  outputs = { self, nixpkgs, antigravity }: {
    # Your configuration here
  };
}
```

Then use in your packages or devShells:

```nix
devShells.default = pkgs.mkShell {
  buildInputs = [ antigravity.packages.${system}.default ];
};
```

### NixOS Configuration

Add to your `configuration.nix`:

```nix
{
  inputs.antigravity.url = "github:TheGostsniperfr/antigravity2.0-nix";
  
  # In your system configuration:
  environment.systemPackages = [
    inputs.antigravity.packages.${pkgs.system}.default
  ];
}
```

### Home Manager

Add to your Home Manager configuration:

```nix
{
  inputs.antigravity.url = "github:TheGostsniperfr/antigravity2.0-nix";
  
  # In your home configuration:
  home.packages = [
    inputs.antigravity.packages.${pkgs.system}.default
  ];
}
```

## Development

### Local Testing

Clone and test locally:

```bash
git clone https://github.com/TheGostsniperfr/antigravity2.0-nix.git
cd REPO
nix flake check
nix build
./result/bin/antigravity --version
```

### Update Manually

To manually update to the latest version:

```bash
nix run .#update
```

Or use the update script:

```bash
./scripts/update.sh
```

## Automatic Updates

This flake automatically checks for new Antigravity releases every 7 days via GitHub Actions. When a new version is detected:

1. The flake is updated with the new version and checksums
2. A pull request is created automatically
3. After review and merge, the new version is available

## Architecture

The flake:
- Fetches version information from Antigravity's official manifest API
- Downloads pre-built binaries from Google Cloud Storage
- Verifies integrity using SHA-512 checksums
- Patches ELF binaries for NixOS compatibility using `autoPatchelfHook`
- Provides a clean, reproducible package

## Supported Platforms

- ✅ Linux x86_64
- ⏳ Linux ARM64 (coming soon)
- ⏳ macOS x86_64 (coming soon)
- ⏳ macOS ARM64 (coming soon)

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Test your changes with `nix flake check`
4. Submit a pull request

## License

This flake is MIT licensed. Antigravity itself is proprietary software by Google.

## Roadmap

### Current Status: v1.0.0 ✅

- ✅ Linux x86_64 support
- ✅ Automatic weekly updates
- ✅ SHA-512 verification
- ✅ CI/CD pipeline
- ✅ Comprehensive documentation

### Upcoming Features

#### v1.1.0 - Multi-Platform Support
- [ ] Linux ARM64 (aarch64) support
- [ ] macOS Intel (x86_64) support  
- [ ] macOS Apple Silicon (ARM64) support
- [ ] Platform-specific testing in CI

#### v1.2.0 - Enhanced Distribution
- [ ] Binary cache setup (Cachix)
- [ ] Faster installation times
- [ ] Reduced bandwidth usage
- [ ] NixOS module for system-wide configuration

#### v1.3.0 - Advanced Features
- [ ] Version pinning support
- [ ] Multiple version installation
- [ ] Plugin packaging
- [ ] Development environment templates

#### v2.0.0 - Ecosystem Integration
- [ ] Nixpkgs overlay
- [ ] Home Manager module
- [ ] NUR (Nix User Repository) integration
- [ ] Flake templates for Antigravity projects

### Community Goals

- 🎯 100+ GitHub stars
- 🎯 Active community contributions
- 🎯 Featured in NixOS Weekly
- 🎯 Official Antigravity documentation mention

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Troubleshooting

### "Unsupported system" error

Currently, only Linux x86_64 is fully supported. Other platforms will be added as Antigravity releases them.

### Binary doesn't run on NixOS

The flake uses `autoPatchelfHook` to fix dynamic linking. If you encounter issues, please open an issue with:
- Your NixOS version
- Output of `nix flake check`
- Error message

### Updates not working

Ensure GitHub Actions has write permissions in your repository settings:
- Settings → Actions → General → Workflow permissions → Read and write permissions
