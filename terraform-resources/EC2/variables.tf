variable "name_prefix" { type = string }
variable "instance_name" {
  type    = string
}
variable "ami" { type = string }
variable "instance_type" {
  type    = string
}
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}

variable "cli_user_name" {
  description = "IAM username to attach SSM session policy for AWS CLI"
  type        = string
  default = "value_not_set" # Set this to your desired CLI user name
}

# Optional, if attaching to role instead
variable "cli_role_name" {
  description = "IAM role name to attach SSM session policy"
  type        = string
  default     = ""
}