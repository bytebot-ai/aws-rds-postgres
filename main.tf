resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Security group for ${var.name_prefix} RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_blocks
  }

  tags = var.tags
}

data "aws_rds_orderable_db_instance" "postgres" {
  engine         = "postgres"
  license_model  = "postgresql-license"
  engine_version = var.engine_version

  preferred_instance_classes = [var.instance_class]
}

resource "aws_db_instance" "this" {
  identifier = var.name_prefix

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = var.storage_encrypted

  db_name  = var.database_name
  username = var.username
  password = var.password
  port     = 5432

  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.deletion_protection

  tags = var.tags
}
