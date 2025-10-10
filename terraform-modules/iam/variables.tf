variable "role_name" {
  type = string
}

variable "assume_role_policy" {
  type = string
}

# Map of extra inline policies per project (policy_name => json policy)
variable "extra_inline_policies" {
  type    = map(string)
  default = {}
}

# List of AWS managed policies to attach
variable "managed_policy_arns" {
  type    = list(string)
  default = []
}

# If you want a “full access” default policy (optional)
variable "full_access_default" {
  type    = bool
  default = false
}