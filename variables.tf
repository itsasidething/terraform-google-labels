

variable "labels" {
  description = "Optional. Labels provided by the calling module. Keys must match GCP label requirements."
  type        = map(string)
  default     = {}
  validation {
    condition     = alltrue([for k in keys(var.labels) : can(regex("^[a-z][a-z0-9_-]{0,62}$", k))])
    error_message = "All label keys must match GCP requirements: ^[a-z][a-z0-9_-]{0,62}$"
  }
}



variable "disable_validation" {
  description = "Optional. Set to true to skip module validation checks (useful for testing)"
  type        = bool
  default     = false
}
