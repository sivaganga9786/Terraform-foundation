variable "name" {
  description = "Name prefix for ALB and TG"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB and TG will be created"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for the internal ALB"
  type        = list(string)
}

variable "app_tag_key" {
  description = "Tag key to filter App instances"
  type        = string
  default     = "Tier"
}

variable "app_tag_value" {
  description = "Tag value to filter App instances"
  type        = string
  default     = "App"
}

variable "app_port" {
  description = "Port on which App servers listen"
  type        = number
  default     = 4000
}

variable "internal_alb_sg_ids" {
  description = "List of Security Group IDs to attach to the internal ALB"
  type        = list(string)
}
