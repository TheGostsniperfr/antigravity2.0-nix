# Contributing to Antigravity Flake

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/antigravity-flake.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`

## Development Setup

Ensure you have Nix with flakes enabled:

```bash
# Check Nix version
nix --version

# Enable flakes (if not already enabled)
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

## Making Changes

### Testing Your Changes

Always test your changes before submitting:

```bash
# Check flake validity
nix flake check

# Build the package
nix build

# Test the binary
./result/bin/antigravity --version

# Test in a clean environment
nix shell .#antigravity --command antigravity --version
```

### Code Style

- Follow existing code patterns
- Use clear, descriptive variable names
- Add comments for complex logic
- Keep functions focused and small

### Commit Messages

Use conventional commit format:

```
type(scope): brief description

Longer description if needed

- Additional details
- More context
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `chore`: Maintenance tasks
- `ci`: CI/CD changes
- `refactor`: Code refactoring

Examples:
```
feat(flake): add support for ARM64 Linux
fix(update): handle missing manifest gracefully
docs(readme): add troubleshooting section
```

## Pull Request Process

1. Update documentation if needed
2. Ensure all tests pass
3. Update CHANGELOG.md if applicable
4. Submit PR with clear description
5. Link related issues
6. Wait for review

### PR Checklist

- [ ] Code builds successfully
- [ ] `nix flake check` passes
- [ ] Documentation updated
- [ ] Commit messages follow convention
- [ ] No merge conflicts

## Reporting Issues

### Bug Reports

Include:
- Clear description
- Steps to reproduce
- Expected vs actual behavior
- Environment details (NixOS version, system, etc.)
- Error messages/logs

### Feature Requests

Include:
- Use case description
- Proposed solution
- Alternative approaches considered
- Examples if applicable

## Code Review

All submissions require review. We aim to:
- Respond within 48 hours
- Provide constructive feedback
- Maintain code quality
- Keep the project maintainable

## Community Guidelines

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn
- Follow the code of conduct

## Questions?

- Open a discussion on GitHub
- Check existing issues and PRs
- Review documentation

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
