locals {
  # Centralized label definitions: each key is a label, value is an object with attributes
  label_definitions = {
    cloudautomation = {
      value         = "tfe"
      forced_value  = true
      default       = false
      required      = false
      condition     = null
      error_message = null
    }
    appid = {
      value         = "0000"
      forced_value  = false
      default       = true
      required      = false
      condition     = null
      error_message = null
    }
    env = {
      value         = null
      forced_value  = false
      default       = false
      required      = true
      condition     = length(lookup(var.labels, "env", "")) > 0
      error_message = "Label 'env' must not be empty."
    }
    costcenter = {
      value         = null
      forced_value  = false
      default       = false
      required      = true
      condition     = can(regex("^[0-9_]+$", lookup(var.labels, "costcenter", "")))
      error_message = "Label 'costcenter' must contain only digits and underscores."
    }
    pii = {
      value         = null
      forced_value  = false
      default       = false
      required      = true
      condition     = lookup(var.labels, "pii", "") == "true" || lookup(var.labels, "pii", "") == "false"
      error_message = "Label 'pii' must be either 'true' or 'false'."
    }
  }

  # Auto-populate mandatory_labels, default_labels, required_label_keys
  mandatory_labels = { for k, v in local.label_definitions : k => v.value if v.forced_value }
  default_labels   = { for k, v in local.label_definitions : k => v.value if v.default }
  required_label_keys = [for k, v in local.label_definitions : k if v.required]

  # Evaluate conditions and collect error messages for failed conditions
  failed_conditions = [for k, v in local.label_definitions : v.error_message if v.condition != null && !v.condition]

  # Internal patterns for label validation (GCP-compatible)
  key_pattern   = "^[a-z][a-z0-9_-]{0,62}$"
  value_pattern = "^[a-z0-9_-]{0,63}$"

  # Filter out all mandatory label keys so callers cannot override them.
  filtered_labels = { for k, v in var.labels : k => v if !contains(keys(local.mandatory_labels), k) }

  # Merge mandatory, default, and user-provided labels (user can override default_labels, but not mandatory_labels).
  merged = merge(local.mandatory_labels, local.default_labels, local.filtered_labels)

  invalid_key_pairs  = [for k, v in local.merged : { key = k, value = v } if !var.disable_validation && !(can(regex(local.key_pattern, k)) && length(regexall(local.key_pattern, k)) > 0)]
  invalid_value_pairs = [for k, v in local.merged : { key = k, value = v } if !var.disable_validation && !(can(regex(local.value_pattern, v)) && length(regexall(local.value_pattern, v)) > 0)]
  missing_required   = [for req in local.required_label_keys : req if !(contains(keys(local.merged), req))]
}