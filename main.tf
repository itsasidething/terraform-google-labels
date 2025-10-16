terraform {
  required_version = ">= 1.3.0"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.1"
    }
  }
}

resource "null_resource" "validation" {
  count = var.disable_validation ? 0 : (
    length(local.invalid_key_pairs) +
    length(local.invalid_value_pairs) +
    length(local.missing_required) +
    length(local.failed_conditions)
    > 0 ? 1 : 0
  )

  provisioner "local-exec" {
    command = join("\n", compact([
      length(local.invalid_key_pairs) > 0 ? format("Invalid GCP label keys found: %s", join(", ", [for p in local.invalid_key_pairs : p.key])) : null,
      length(local.invalid_value_pairs) > 0 ? format("Invalid GCP label values found for keys: %s", join(", ", [for p in local.invalid_value_pairs : p.key])) : null,
      length(local.missing_required) > 0 ? format("Missing required label keys: %s", join(", ", local.missing_required)) : null,
      length(local.failed_conditions) > 0 ? format("Failed label value conditions: %s", join(" | ", local.failed_conditions)) : null,
      "See README.md for rules and how to override patterns."
    ]))

    interpreter = ["/bin/sh", "-c"]
  }
}
