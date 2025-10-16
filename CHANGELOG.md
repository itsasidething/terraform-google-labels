# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-16

### Added
- Initial release of terraform-google-labels module
- Centralized label management with forced, default, and required labels
- Plan-time validation using lifecycle preconditions (requires Terraform >= 1.4.0)
- Configurable label definitions in `locals.tf` for easy maintenance
- Custom per-label conditions and error messages
- GCP-compatible label key/value validation
- Variable validation blocks for early input checks
- Comprehensive documentation and examples
- CI/CD workflow for automated validation

### Features
- Forced labels: `cloudautomation = "tfe"` (non-overridable)
- Default labels: `appid = "0000"` (overridable)
- Required labels: `env`, `costcenter`, `pii` (must be provided)
- Custom validation rules:
  - `costcenter` must contain only digits and underscores
  - `pii` must be "true" or "false"
  - `env` must not be empty
- `disable_validation` flag for testing scenarios
