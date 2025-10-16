
resource "null_resource" "validation" {
  count = var.disable_validation ? 0 : (length(local.invalid_key_pairs) + length(local.invalid_value_pairs) + length(local.missing_required) > 0 ? 1 : 0)

  provisioner "local-exec" {
    command = join("\n", compact([
      length(local.invalid_key_pairs) > 0 ? format("Invalid label keys found: %s", join(", ", [for p in local.invalid_key_pairs : p.key])) : null,
      length(local.invalid_value_pairs) > 0 ? format("Invalid label values found for keys: %s", join(", ", [for p in local.invalid_value_pairs : p.key])) : null,
      length(local.missing_required) > 0 ? format("Missing required label keys: %s", join(", ", local.missing_required)) : null,
      "See README.md for rules and how to override patterns."
    ]))

    interpreter = ["/bin/sh", "-c"]
  }
}
