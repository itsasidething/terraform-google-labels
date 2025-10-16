Centralized reusable labels module


This module centralizes label handling for Google Cloud (or other providers). It merges provided labels with organization-mandated, default, and required labels, validates keys and values against internal regex patterns (not user-overridable), and ensures required label keys are present.

Contract
- Inputs:
  - labels: map(string) - labels passed by the caller
  - disable_validation: bool - set true to skip validation (for tests)
- Outputs:
  - labels: map(string) - merged and validated labels ready to pass to resources
  - validation_failed: bool - true when required keys are missing (note: validation is enforced at apply time)

Label logic
- Mandatory (non-overridable) labels: always present, cannot be changed by input (see `mandatory_labels` in `locals.tf`).
- Default labels: present unless overridden by input (see `default_labels` in `locals.tf`).
- Required label keys: must be present in the final merged labels, values can be anything (see `required_label_keys` in `locals.tf`).
- Label key/value validation: uses internal regex patterns (see `key_pattern` and `value_pattern` in `locals.tf`). These patterns are not user-overridable.

Usage
Use this module by calling the repository root as a module source, or copy the files into other repos where you want the same logic.

Notes
- Some validation (missing required keys) runs as a failing local-exec provisioner which will abort apply with a clear message. This intentionally ensures enforcement in TFE applies. If you prefer early-plan validation, consider adding Sentinel/Opa/Gate checks in your CI/TFE.
