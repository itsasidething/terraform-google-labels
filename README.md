
# terraform-google-labels

This repository provides a reusable, centralized Terraform module for handling labels across your organization. The module is now located in the repository root for easy consumption and publishing. Example usage is provided in `examples/simple`.

## Module contract
**Inputs:**
- `labels` (map(string)): caller-supplied labels
- `disable_validation` (bool): set true to skip validation (for tests)

**Outputs:**
- `labels` (map(string)): merged labels
- `validation_failed` (bool): true if validation rules fail

**Behavior:**
- Always includes the following mandatory labels (cannot be overridden by caller input):
  - `cloudautomation = "tfe"`
- Includes a default label `appid = "0000"` which can be overridden by the caller by providing `appid` in `labels`.
- Merges caller labels with mandatory/default labels; caller-provided `appid` will override the default, but `cloudautomation` is protected.
- Validates keys and values using internal regex patterns (not user-overridable) and fails apply via a `null_resource` local-exec when validation fails

Additionally, callers must provide the following label keys in their `labels` input (values may be anything):

- `costcenter`
- `pii`

These two keys are appended to the module's internal required keys for validation.

## Example usage

See `examples/simple/main.tf`

## Edge cases
- If required keys are missing, apply fails with a clear error.
- If label keys/values do not match regex, apply fails.
- Set `disable_validation = true` for testing or to skip enforcement.
