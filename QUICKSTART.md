# Quick Start Guide

Get up and running with Antigravity in under 5 minutes.

## Prerequisites

You need Nix with flakes enabled. If you don't have it:

```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Restart your terminal.

## Try It Now

Run Antigravity without installing:

```bash
nix run github:YOUR_USERNAME/antigravity-flake -- --version
```

## Install

Install to your user profile:

```bash
nix profile install github:YOUR_USERNAME/antigravity-flake
```

Verify:

```bash
antigravity --version
```

## Use It

```bash
# Get help
antigravity --help

# View changelog
antigravity changelog

# Start interactive session
antigravity -i "help me build a web app"

# Run single prompt
antigravity -p "explain this code" --add-dir ./src
```

## Update

The flake auto-updates weekly. To update manually:

```bash
nix profile upgrade antigravity
```

## Uninstall

```bash
nix profile remove antigravity
```

## Next Steps

- Read the full [README](README.md)
- Check [Setup Guide](docs/SETUP.md) for advanced installation
- See [Architecture](docs/ARCHITECTURE.md) for technical details
- Visit [Antigravity Docs](https://antigravity.google) for CLI usage

## Need Help?

- [Open an issue](https://github.com/YOUR_USERNAME/antigravity-flake/issues)
- Check [Troubleshooting](docs/SETUP.md#troubleshooting)
