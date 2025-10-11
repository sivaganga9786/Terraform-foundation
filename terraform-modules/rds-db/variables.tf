variable "db_instance_identifier" { type = string }
variable "db_subnet_group_name" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "engine" { type = string }
variable "engine_version" { type = string }
variable "instance_class" { type = string }
variable "allocated_storage" { type = number }
variable "multi_az" { type = bool }
variable "storage_type" { type = string }
variable "publicly_accessible" { type = bool }
variable "backup_retention_period" { type = number }
variable "vpc_security_group_ids" { type = list(string) }
variable "skip_final_snapshot" {
  type    = bool
}
variable "final_snapshot_identifier" {
  type    = string
  default = ""
}
variable "deletion_protection" {
  type    = bool
  default = false
}
