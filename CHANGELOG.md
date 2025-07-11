# [1.1.0](https://github.com/mccrackenyyc/terraform-modules/compare/v1.0.0...v1.1.0) (2025-07-11)


### Bug Fixes

* **ci:** access token for semantic-release ([#16](https://github.com/mccrackenyyc/terraform-modules/issues/16)) ([33a3f62](https://github.com/mccrackenyyc/terraform-modules/commit/33a3f623fc32d88fba3124c4af3260e2ff8a884b))
* **ci:** correct pipeline output format for GitHub Actions ([#15](https://github.com/mccrackenyyc/terraform-modules/issues/15)) ([593d983](https://github.com/mccrackenyyc/terraform-modules/commit/593d983092ba8444aa4df669427440e8c8963456))
* **network:** improve vnet-subnet module documentation formatting ([#19](https://github.com/mccrackenyyc/terraform-modules/issues/19)) ([70c6785](https://github.com/mccrackenyyc/terraform-modules/commit/70c67855fbf8daf8cdf03cae5c2131f65219c5c4))


### Features

* **ci:** add automated release pipeline ([#12](https://github.com/mccrackenyyc/terraform-modules/issues/12)) ([81dba39](https://github.com/mccrackenyyc/terraform-modules/commit/81dba39175996c867f2a711aee28d469c7bbe315))

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Automated release pipeline with semantic versioning
- TFLint configuration with Azure-specific rules
- Conventional commits documentation

## [1.0.0] - 2025-07-07

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
