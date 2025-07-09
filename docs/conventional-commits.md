# Conventional Commits for terraform-modules

This repository uses [Conventional Commits](https://www.conventionalcommits.org/) for automated changelog generation and semantic versioning.

## Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types

| Type | Description | Version Bump |
|------|-------------|--------------|
| `feat` | New feature or module | Minor (1.x.0) |
| `fix` | Bug fix | Patch (1.0.x) |
| `docs` | Documentation changes | Patch (1.0.x) |
| `style` | Code formatting (no logic changes) | Patch (1.0.x) |
| `refactor` | Code refactoring | Patch (1.0.x) |
| `test` | Adding or updating tests | Patch (1.0.x) |
| `chore` | Maintenance tasks | Patch (1.0.x) |
| `ci` | CI/CD changes | Patch (1.0.x) |

## Breaking Changes

Add `BREAKING CHANGE:` in the footer or `!` after the type to trigger a major version bump:

```
feat!: redesign network module API

BREAKING CHANGE: subnet configuration format has changed
```

## Examples

### New Module
```
feat(network): add application gateway module

- Support for WAF configuration
- SSL certificate management
- Backend pool configuration
```

### Bug Fix
```
fix(network): correct subnet delegation validation

Fixes issue where valid delegations were rejected
```

### Documentation
```
docs(network): improve vnet-subnet usage examples

Add examples for App Service integration and private endpoints
```

### Breaking Change
```
feat(network)!: simplify subnet configuration

BREAKING CHANGE: subnet names are now auto-generated from keys
```

## Scopes (Optional)

Use scopes to indicate which module category is affected:

- `network` - Network-related modules
- `compute` - Compute-related modules  
- `storage` - Storage-related modules
- `security` - Security-related modules
- `ci` - CI/CD and tooling

## Release Process

1. **Commit with conventional format** - Pipeline will automatically detect version bump needed
2. **Merge to main** - semantic-release will:
   - Generate changelog
   - Create Git tag
   - Create GitHub release
   - Update CHANGELOG.md

## No Release Scenarios

These commit types will **not** trigger a release:
- Commits without conventional format
- Commits with `[skip ci]` in the message
- Merge commits from automated tools

## Tips

- Use imperative mood: "add feature" not "added feature"
- Keep description under 50 characters when possible
- Use body for detailed explanations
- Reference issues: "Fixes #123"