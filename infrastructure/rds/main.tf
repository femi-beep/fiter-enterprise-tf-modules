locals {
  db_port = "3306"
  tags = {
    Name  = "fineract-${var.client}-${var.environment}"
    Owned = "Terraform"
  }
}

resource "aws_security_group" "service" {
  name        = "${var.client}-${var.environment}-rds-sg"
  description = "Allow inbound traffic to RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow RDS connection from inside VPC"
    from_port   = local.db_port
    to_port     = local.db_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.vpc_cidr_block]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

# db_instance_master_user_secret_arn

module "db" {
  source                      = "terraform-aws-modules/rds/aws"
  version                     = "6.0.0"
  identifier                  = "fiter-${var.client}-${var.environment}"
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  allocated_storage           = var.db_storage_size
  allow_major_version_upgrade = false

  db_name                         = var.initial_db_name
  username                        = var.username
  port                            = local.db_port
  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_names
  vpc_security_group_ids          = [aws_security_group.service.id]

  backup_retention_period = var.backup_retention_period
  maintenance_window      = var.maintenance_window
  backup_window           = var.backup_window


  manage_master_user_password = var.manage_master_user_password
  monitoring_interval         = var.monitoring_interval
  monitoring_role_name        = "${var.client}-${var.environment}RDSMonitoringRole"
  create_monitoring_role      = var.create_monitoring_role

  tags = local.tags

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.private_subnets #module.vpc.public_subnets

  # DB parameter group
  family = var.rds_family

  # DB option group
  major_engine_version = var.major_engine_version

  # Database Deletion Protection
  deletion_protection = var.rds_db_delete_protection
  publicly_accessible = false # set to false to enforce it is not publicly accessible

}