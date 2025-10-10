# modules/db_subnet_group/main.tf
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.db_subnets
  description = "Subnet group for ${var.project_name} RDS instance"

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}



