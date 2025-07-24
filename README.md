# terraform-modules

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=flat&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)

Reusable Terraform modules for Azure infrastructure. Primarily developed for personal projects but available for public use.

## Quick Start

```hcl
module "example" {
  source = "git::https://github.com/mccrackenyyc/terraform-modules.git//templates/network/vnet-subnet?ref=v1.0.0"
  
  # See module documentation for configuration options
}
```

## Available Modules

### Network
| Module | Description |
|--------|-------------|
| [vnet-subnet](./templates/network/vnet-subnet) | Virtual Network with configurable subnets |

## Usage Guidelines

### Versioning
This repository uses semantic versioning with Git tags. It's strongly recommended to pin to a specific version in production:

```hcl
# ✅ Recommended - pinned to specific version
source = "git::https://github.com/mccrackenyyc/terraform-modules.git//templates/network/vnet-subnet?ref=v1.0.0"

# ⚠️ Use with caution - uses latest main branch (acceptable for personal projects)
source = "git::https://github.com/mccrackenyyc/terraform-modules.git//templates/network/vnet-subnet?ref=main"
```

### Module Structure
Modules are organized by category under the `templates/` directory:
```
templates/
├── network/
│   └── vnet-subnet/
├── compute/
├── storage/
└── security/
```

## Requirements

- **Terraform**: >= 1.12
- **Azure Provider**: >= 4.0
- **Azure CLI**: Authenticated with appropriate permissions

## Cloud Support

This repository is **Azure-only**. All modules are designed specifically for Microsoft Azure infrastructure.

## Pipelines

This repository uses automated pipelines for documentation, validation, and releases.

### Documentation Pipeline
- **Auto-Generation**: Commits updated module documentation to PRs when .tf files change

### Validation and Release Pipeline  
- **Change Detection**: Validates only changed modules on PRs for efficiency
- **Parallel Validation**: Independent validation jobs for faster feedback
- **Rule Change Handling**: Re-validates all modules when linting/security rules change
- **Automated Releases**: Semantic versioning with changelog generation on main branch merges

See [Conventional Commits](docs/conventional-commits.md) for commit format details.

### Authentication Requirements

**Important**: The validation and release pipeline requires a Personal Access Token (PAT) for protected branch access.

#### Why PAT is Required

semantic-release needs to push changelog commits and create releases on protected branches. The default `GITHUB_TOKEN` has insufficient permissions for these operations on protected branches.

#### Setting Up Authentication

1. **Create a Fine-Grained Personal Access Token**:
   - Go to [GitHub Fine-Grained Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token)
   - Set repository access to this repository only
   - Configure the following **Repository permissions**:
     - **Contents**: Read and write *(for pushing changelog commits)*
     - **Metadata**: Read *(for repository information)*
     - **Issues**: Write *(for linking releases to issues)*
     - **Pull requests**: Write *(for updating PR statuses)*
     - **Actions**: Read *(for workflow context)*

2. **Add Token as Repository Secret**:
   - Go to repository **Settings → Secrets and variables → Actions**
   - Create new repository secret named `SEMANTIC_RELEASE_TOKEN`
   - Paste your PAT as the value

3. **Configure Branch Protection**:
   - Ensure **"Allow specified actors to bypass required pull requests"** is enabled
   - Add users with repository admin role to the bypass list

## Development

### Module Standards
- Follow Azure CAF naming conventions
- Include comprehensive variable validation
- Provide meaningful outputs
- Use consistent tagging strategies
- Include module-specific documentation

### Contribution Guidelines
While primarily developed for personal use, contributions are welcome:

1. Fork the repository
2. Create a feature branch
3. Follow existing module patterns
4. Test your changes thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

This is a portfolio project by Scott McCracken. For questions or issues, please use the GitHub issue tracker.