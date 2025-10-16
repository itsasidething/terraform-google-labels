# terraform-google-labels

This module provides a reusable, centralized way to manage labels for Google Cloud resources. It enforces organization-mandated, default, and required labels, validates keys/values, and supports custom conditions.

## Requirements

- Terraform >= 1.3.0
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

- Always includes the following mandatory labels (cannot be overridden): `cloudautomation = "tfe"`
- Includes a default label `appid = "0000"` (can be overridden by the caller)
- Merges caller labels with mandatory/default labels
- Validates keys and values using internal regex patterns (not user-overridable)
- Custom per-label conditions and error messages

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

- If required keys are missing, apply fails with a clear error.
- If label keys/values do not match regex, apply fails.
- Set `disable_validation = true` for testing or to skip enforcement.

