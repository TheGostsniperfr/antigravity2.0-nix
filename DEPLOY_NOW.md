# 🚀 Ready to Deploy!

Your Antigravity 2.0 Nix Flake is production-ready.

## Quick Deploy

### 1. Create GitHub Repository

Create a new repository on GitHub with your preferred name (e.g., `antigravity-nix`).

### 2. Update Repository URLs

```bash
# Replace USERNAME/REPO with your actual GitHub username and repo name
# Example: bperret/antigravity-nix
find . -type f -name "*.md" -exec sed -i 's|USERNAME/REPO|your-username/your-repo|g' {} +

git add -A
git commit -m "chore: update repository URLs"
```

### 3. Push to GitHub

```bash
# Add remote
git remote add origin https://github.com/USERNAME/REPO.git

# Push
git push -u origin main

# Create and push tag
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

### 4. Configure GitHub Actions

Go to **Settings → Actions → General**:
- Workflow permissions: "Read and write permissions"
- ✓ Allow GitHub Actions to create and approve pull requests

### 5. Test Installation

```bash
nix run github:USERNAME/REPO -- --version
```

## ✅ Done!

Your flake is now:
- ✓ Live on GitHub
- ✓ Installable by anyone
- ✓ Auto-updating every 7 days

## Share

Announce on:
- [NixOS Discourse](https://discourse.nixos.org/)
- [r/NixOS](https://reddit.com/r/NixOS)

---

**Built for the Nix community**
