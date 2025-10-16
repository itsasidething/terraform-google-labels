
variable "labels" {
  description = "Optional. Labels provided by the calling module"
  type        = map(string)
  default     = {}
}



variable "disable_validation" {
  description = "Optional. Set to true to skip module validation checks (useful for testing)"
  type        = bool
  default     = false
}
