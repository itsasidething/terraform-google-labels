
output "labels" {
  description = "Final labels that passed validation and defaults/overrides applied"
  value       = local.merged
  sensitive   = false
}

output "validation_failed" {
  description = "True when validation would fail (useful if you want to assert in calling module)"
  value       = !var.disable_validation && (length(local.invalid_key_pairs) + length(local.invalid_value_pairs) + length(local.missing_required) > 0)
}
