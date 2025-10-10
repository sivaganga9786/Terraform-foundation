variable "project_name" {
  type        = string
  description = "Project name for tagging and naming"
}

variable "db_subnets" {
  type        = list(string)
  description = "List of private subnet IDs for the DB subnet group"
}

variable "project_name" {
  type        = string
}

variable "db_subnet_group_name" {
  type        = string
}

variable "db_username" {
  type        = string
}

variable "db_password" {
  type        = string
  sensitive   = true
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}