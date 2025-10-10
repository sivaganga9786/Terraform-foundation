variable "policy_name" {
  type        = string
  description = "Name of the custom managed policy"
}

variable "policy_description" {
  type        = string
  default     = "Custom managed policy"
}

variable "policy_document" {
  type        = string
  description = "JSON policy document"
}

variable "role_name" {
  type = string
}

variable "assume_role_policy" {
  type = string
}

variable "managed_policy_arns" {
  type    = list(string)
  default = []
}

variable "extra_inline_policies" {
  type    = map(string)
  default = {}
}
