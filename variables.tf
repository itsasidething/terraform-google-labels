

variable "labels" {
  description = <<-EOT
    Labels provided by the calling module. All labels must comply with GCP requirements.
    
    Required keys (must be provided):
    - env: Environment identifier (e.g., "prd", "dev", "stg")
    - costcenter: Cost center identifier (digits and underscores only, e.g., "123_456")
    - pii: Whether the resource handles PII data (must be "true" or "false")
    
    Reserved keys (cannot be overridden):
    - cloudautomation: Managed by this module, set to "tfe"
    
    Default keys (can be overridden):
    - appid: Application ID (defaults to "0000")
    
    Example:
    labels = {
      env        = "prd"
      costcenter = "123_456_789"
      pii        = "false"
      appid      = "4200"
    }
  EOT
  type        = map(string)
  default     = {}
  validation {
    condition     = alltrue([for k in keys(var.labels) : can(regex("^[a-z][a-z0-9_-]{0,62}$", k))])
    error_message = "All label keys must match GCP requirements: ^[a-z][a-z0-9_-]{0,62}$"
  }

  validation {
    condition     = alltrue([for v in values(var.labels) : can(regex("^[a-z0-9_-]{0,63}$", v))])
    error_message = "All label values must match GCP requirements: ^[a-z0-9_-]{0,63}$"
  }

  validation {
    condition     = can(regex("^[0-9_]+$", lookup(var.labels, "costcenter", "")))
    error_message = "Label 'costcenter' must contain only digits and underscores."
  }

  validation {
    condition     = lookup(var.labels, "pii", "") == "true" || lookup(var.labels, "pii", "") == "false"
    error_message = "Label 'pii' must be either 'true' or 'false'."
  }
}


variable "disable_validation" {
  description = <<-EOT
    Set to true to skip all validation checks. Useful for testing or special scenarios.
    When enabled, plan-time validation will be bypassed and invalid labels may be created.
    Default: false
  EOT
  type        = bool
  default     = false
}
