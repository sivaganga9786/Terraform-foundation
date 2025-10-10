resource "aws_db_subnet_group" "this" {
  name        = "${var.project_name}-db-subnet-group"
  subnet_ids  = var.db_subnets
  description = "Subnet group for ${var.project_name} RDS instance"

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}



resource "aws_db_instance" "this" {
  identifier              = "${var.project_name}-mysql-db"
  allocated_storage       = var.allocated_storage
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = var.db_subnet_group_name
  vpc_security_group_ids  = var.vpc_security_group_ids
  multi_az                = var.multi_az
  storage_type            = var.storage_type
  publicly_accessible     = var.publicly_accessible
  backup_retention_period = var.backup_retention_period

  tags = {
    Name = "${var.project_name}-mysql-db"
  }
}

