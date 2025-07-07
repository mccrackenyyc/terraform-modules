# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-07

### Added
- Initial release of terraform-modules repository
- **Network Module**: `vnet-subnet` - Virtual Network with configurable subnets
  - Support for multiple subnets with flexible configuration
  - Private endpoint network policies management
  - Service endpoints integration for Azure PaaS services
  - Subnet delegation support for specialized services
  - Comprehensive input validation and outputs
- Project documentation including README.md with usage guidelines
- MIT License
- Semantic versioning strategy with Git tags

### Infrastructure
- Repository structure with modules organized by category under `templates/`
- Module documentation standards and examples
- Azure-focused module design following CAF conventions

[1.0.0]: https://github.com/mccrackenyyc/terraform-modules/releases/tag/v1.0.0