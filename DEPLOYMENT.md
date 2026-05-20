# Deployment Checklist

Follow this checklist when deploying the Antigravity Nix flake to GitHub.

## Pre-Deployment

- [x] Flake builds successfully
- [x] Binary executes correctly
- [x] Update script works
- [x] Documentation is complete
- [x] CI/CD workflows configured
- [x] License file present
- [x] .gitignore configured

## GitHub Repository Setup

### 1. Create Repository

```bash
# On GitHub, create a new repository named: antigravity-flake
# Description: "Nix flake for Antigravity 2.0 CLI with automatic updates"
# Public repository
# Don't initialize with README (we have one)
```

### 2. Update Repository URLs

Replace `YOUR_USERNAME` in these files:
- [ ] README.md (all occurrences)
- [ ] QUICKSTART.md
- [ ] docs/SETUP.md
- [ ] CHANGELOG.md
- [ ] STATUS.md

```bash
# Quick find and replace
find . -type f -name "*.md" -exec sed -i 's/YOUR_USERNAME/your-github-username/g' {} +
```

### 3. Push to GitHub

```bash
# Add remote
git remote add origin https://github.com/YOUR_USERNAME/antigravity-flake.git

# Push
git push -u origin main
```

### 4. Configure GitHub Settings

#### Repository Settings
- [ ] Go to Settings → General
- [ ] Add description: "Nix flake for Antigravity 2.0 CLI with automatic updates"
- [ ] Add topics: `nix`, `nixos`, `flake`, `antigravity`, `cli`, `google`
- [ ] Add website: `https://antigravity.google`

#### GitHub Actions
- [ ] Go to Settings → Actions → General
- [ ] Workflow permissions: "Read and write permissions"
- [ ] Check "Allow GitHub Actions to create and approve pull requests"

#### Branch Protection (Optional but Recommended)
- [ ] Go to Settings → Branches
- [ ] Add rule for `main` branch:
  - [ ] Require pull request reviews before merging
  - [ ] Require status checks to pass (CI)
  - [ ] Require branches to be up to date

### 5. Create Initial Release

```bash
# Tag the release
git tag -a v1.0.0 -m "Initial release of Antigravity Nix flake"
git push origin v1.0.0
```

On GitHub:
- [ ] Go to Releases → Create a new release
- [ ] Choose tag: v1.0.0
- [ ] Title: "v1.0.0 - Initial Release"
- [ ] Description: Copy from CHANGELOG.md
- [ ] Publish release

### 6. Enable GitHub Features

- [ ] Go to Settings → Features
- [ ] Enable Issues
- [ ] Enable Discussions (optional)
- [ ] Enable Projects (optional)

### 7. Add Repository Secrets (if needed)

For future enhancements:
- [ ] Settings → Secrets and variables → Actions
- [ ] Add any required secrets (none needed currently)

## Post-Deployment

### 1. Test Installation

```bash
# Test from GitHub
nix run github:YOUR_USERNAME/antigravity-flake -- --version

# Test installation
nix profile install github:YOUR_USERNAME/antigravity-flake
antigravity --version
```

### 2. Verify CI/CD

- [ ] Check Actions tab
- [ ] Verify CI workflow runs on push
- [ ] Verify update workflow is scheduled

### 3. Update Documentation

- [ ] Add actual GitHub URLs to README badges
- [ ] Update STATUS.md with repository stats
- [ ] Add contributors if applicable

### 4. Community Setup

Create these files on GitHub:
- [ ] Add repository description
- [ ] Add topics/tags
- [ ] Pin important issues
- [ ] Create initial discussion threads (optional)

### 5. Announce

Share your flake:
- [ ] NixOS Discourse
- [ ] Reddit r/NixOS
- [ ] Twitter/X
- [ ] Your blog/website

## Maintenance Schedule

### Weekly
- [ ] Check for auto-update PRs
- [ ] Review and merge updates
- [ ] Monitor CI/CD status

### Monthly
- [ ] Review open issues
- [ ] Update documentation if needed
- [ ] Check dependency updates

### Quarterly
- [ ] Review and update roadmap
- [ ] Evaluate new features
- [ ] Community feedback review

## Troubleshooting

### Auto-update not working
1. Check GitHub Actions permissions
2. Verify workflow file syntax
3. Check cron schedule
4. Review workflow logs

### CI failing
1. Check Nix version compatibility
2. Verify flake.lock is committed
3. Review error logs
4. Test locally first

### Users can't install
1. Verify repository is public
2. Check flake.nix syntax
3. Test with fresh Nix installation
4. Review user's Nix configuration

## Rollback Plan

If something goes wrong:

```bash
# Revert to previous commit
git revert HEAD
git push origin main

# Or reset to specific version
git reset --hard v1.0.0
git push --force origin main

# Delete problematic tag
git tag -d v1.0.1
git push origin :refs/tags/v1.0.1
```

## Success Criteria

- [x] Repository is public and accessible
- [ ] CI/CD workflows are green
- [ ] Installation works from GitHub
- [ ] Documentation is accurate
- [ ] Auto-updates are scheduled
- [ ] Community can contribute

## Next Steps

After successful deployment:
1. Monitor first auto-update cycle
2. Gather user feedback
3. Plan next version features
4. Engage with community

---

**Deployment Date:** _____________________  
**Deployed By:** _____________________  
**Repository URL:** https://github.com/YOUR_USERNAME/antigravity-flake
