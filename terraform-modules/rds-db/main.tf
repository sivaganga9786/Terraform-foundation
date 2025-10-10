# modules/mysql_db/main.tf
resource "aws_db_instance" "this" {
  identifier              = var.db_instance_identifier
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
  skip_final_snapshot = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier != "" ? var.final_snapshot_identifier : null

  tags = { Name = var.db_instance_identifier }
}

