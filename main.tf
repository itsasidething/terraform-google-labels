// Plan-time validation is implemented via variable validation rules in `variables.tf`
// combined with lifecycle preconditions on a check resource for dynamic validation
// based on locals (e.g., reserved labels from label_definitions).

resource "null_resource" "plan_time_check" {
  count = var.disable_validation ? 0 : 1

  lifecycle {
    precondition {
      condition     = length([for k in keys(var.labels) : k if contains(keys(local.mandatory_labels), k)]) == 0
      error_message = "Cannot override reserved/forced labels. Remove keys: ${join(", ", [for k in keys(var.labels) : k if contains(keys(local.mandatory_labels), k)])}"
    }

    precondition {
      condition     = length(local.missing_required) == 0
      error_message = "Missing required label keys: ${join(", ", local.missing_required)}"
    }

    precondition {
      condition     = length(local.failed_conditions) == 0
      error_message = "Failed label value conditions: ${join(" | ", local.failed_conditions)}"
    }

    precondition {
      condition     = length(local.invalid_key_pairs) == 0
      error_message = "Invalid GCP label keys found: ${join(", ", [for p in local.invalid_key_pairs : p.key])}"
    }

    precondition {
      condition     = length(local.invalid_value_pairs) == 0
      error_message = "Invalid GCP label values found for keys: ${join(", ", [for p in local.invalid_value_pairs : p.key])}"
    }
  }
}
