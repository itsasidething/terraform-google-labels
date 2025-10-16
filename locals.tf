locals {
  # Define all mandatory, non-overridable labels in one place for easy maintenance.
  mandatory_labels = {
    cloudautomation  = "tfe"
  }

  # Define default label values (can be overridden by user input) in one place for easy maintenance.
  default_labels = {
    appid = "0000"
  }

  # Define required label keys (values can be anything) in one place for easy maintenance.
  required_label_keys = ["env","costcenter", "pii"]

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