# terraform-google-labels

[![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.4.0-blue)](https://www.terraform.io/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

This module provides a reusable, centralized way to manage labels for Google Cloud resources. It enforces organization-mandated, default, and required labels, validates keys/values, and supports custom conditions.

> **Note**: All validation runs at **plan-time**, ensuring invalid configurations are caught before any infrastructure changes.

## Requirements

- Terraform >= 1.4.0
- null provider >= 3.2.1

## Inputs

| Name    | Description | Type | Default |
|---------|-------------|------|---------|
| labels  | Labels provided by the calling module. Keys must match GCP requirements. | map(string) | `{}` |
| disable_validation | Set true to skip module validation checks (useful for testing) | bool | `false` |

## Outputs

| Name   | Description |
|--------|-------------|
| labels | Merged labels (defaults overwritten by caller labels) |
| validation_failed | True if validation rules fail |

## Features

- Always includes mandatory labels (cannot be overridden)
- Includes default labels (can be overridden by caller)
- Enforces required label keys
- Validates keys and values using internal GCP-compatible regex patterns
- Custom per-label conditions and error messages
- **Plan-time validation**: All checks run during `terraform plan`, preventing invalid configurations before apply

## Example

```hcl
module "labels" {
  source = "./" # or your registry source
  labels = {
    env        = "prod"
    costcenter = "111_222_333_444"
    pii        = "true"
    appid      = "4200"
  }
}
```

## Edge Cases

- **Plan-time enforcement**: If required keys are missing, invalid keys/values are present, or reserved labels are overridden, the plan will fail immediately with a clear error message.
- Set `disable_validation = true` for testing or to skip enforcement.
- Custom label conditions (e.g., `costcenter` format, `pii` values) are defined in `locals.tf` and evaluated at plan time.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes and test them
4. Run `terraform fmt -recursive` and `terraform validate`
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Maintenance

To modify label definitions:

1. Edit `label_definitions` in `locals.tf`
2. Each label has these attributes:
   - `value`: Default value (required)
   - `forced_value`: If true, cannot be overridden by caller
   - `default`: If true, provides a default that can be overridden
   - `required`: If true, must be present in final merged labels
   - `condition`: Optional validation expression
   - `error_message`: Optional custom error message for failed condition

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Authors

Maintained by the terraform-google-labels contributors.

