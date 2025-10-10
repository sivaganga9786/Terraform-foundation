variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "assume_role_policy" {
  type        = string
  description = "IAM assume role policy in JSON format"
}

variable "managed_policy_arns" {
  type        = list(string)
  default     = []
  description = "List of managed policy ARNs to attach to the role"
}

variable "custom_managed_policies" {
  type        = map(string)
  default     = {}
  description = "Custom managed policies to create and attach (policy_name => JSON document)"
}

variable "extra_inline_policies" {
  type        = map(string)
  default     = {}
  description = "Inline policies to attach to the role (policy_name => JSON document)"
}
