variable "project_name" {
  type = string
}

variable "db_subnets" {
  type = list(string)
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "vpc_security_group_ids" {
  type = list(string)
  default = []
}

variable "engine" {
  type = string
  default = "mysql"
}

variable "engine_version" {
  type = string
  default = "8.0.28"
}

variable "instance_class" {
  type = string
  default = "db.t4g.micro"
}

variable "allocated_storage" {
  type = number
  default = 20
}

variable "multi_az" {
  type = bool
  default = false
}

variable "storage_type" {
  type = string
  default = "gp2"
}

variable "publicly_accessible" {
  type = bool
  default = false
}

variable "backup_retention_period" {
  type = number
  default = 7
}

variable "db_instance_identifier" {
  type = string
  default = null
}
