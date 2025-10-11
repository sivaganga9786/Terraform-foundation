# variable "instances" {
#   type = list(object({
#     name          = string
#     ami           = string
#     instance_type = string
#   }))
# }

# variable "subnet_id" {}
# variable "key_name" {}
# variable "user_data" {
#   type = list(string)
# }
# variable "ec2_sg_name" {
#   description = "The name of the EC2 security group"
#   type        = string
# }
# variable "vpc_id" {
#   description = "The ID of the VPC where EC2 and its security group will be created"
#   type        = string
# }
# variable "volume_size" {
#   default = 8
# }


variable "project_name" {}
variable "role" {}
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_group_ids" {
  type = list(string)
}
variable "iam_instance_profile" {}
variable "user_data" {
  type    = string
  default = ""
}
variable "tags" {
  type    = map(string)
  default = {}
}
