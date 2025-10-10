variable "role_name" {
  type        = string
  description = "Name of the IAM Role"
}

variable "assume_role_policy" {
  type        = string
  description = "Assume role policy JSON"
}

variable "managed_policy_arns" {
  type    = list(string)
  default = []
  description = "List of AWS managed policy ARNs"
}

variable "custom_managed_policies" {
  type    = map(string)
  default = {}
  description = "Map of custom managed policies: name = JSON document"
}

variable "extra_inline_policies" {
  type    = map(string)
  default = {}
  description = "Extra inline policies"
}
