Centralized reusable labels module


This module centralizes label handling for Google Cloud (or other providers). It merges provided labels with organization-mandated, default, and required labels, validates keys and values against internal regex patterns (not user-overridable), and ensures required label keys are present.

Contract
- Inputs:
  - labels: map(string) - labels passed by the caller
  - disable_validation: bool - set true to skip validation (for tests)
- Outputs:
  - labels: map(string) - merged and validated labels ready to pass to resources
  - validation_failed: bool - true when validation rules fail

Label logic
- Mandatory (forced) labels: always present, cannot be changed by input (see `label_definitions` with `forced_value = true` in `locals.tf`).
- Default labels: present unless overridden by input (see `label_definitions` with `default = true` in `locals.tf`).
- Required label keys: must be present in the final merged labels, values can be anything (see `label_definitions` with `required = true` in `locals.tf`).
- Label key/value validation: uses internal regex patterns (see `key_pattern` and `value_pattern` in `locals.tf`). These patterns are not user-overridable.
- Custom conditions: per-label validation rules with custom error messages (see `condition` and `error_message` in `label_definitions`).

Validation approach
- **Plan-time validation**: All validation rules are enforced during `terraform plan` via:
  - Variable validation blocks in `variables.tf` for basic key/value format checks
  - Lifecycle preconditions on a `null_resource` in `main.tf` for dynamic checks based on merged labels and `label_definitions`
- If any validation fails, the plan will fail with a clear error message before any infrastructure changes are attempted.

Usage
Use this module by calling the repository root as a module source, or copy the files into other repos where you want the same logic.

Maintenance
- To add/modify/remove labels: edit `label_definitions` in `locals.tf`
- Each label has attributes: `value`, `forced_value`, `default`, `required`, `condition`, `error_message`
- All derived lists (`mandatory_labels`, `default_labels`, `required_label_keys`) are auto-populated from `label_definitions`
