################################################################################
# RDS Aurora Module
################################################################################

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.13.0"

  name                   = var.db_identifier
  port                   = var.port
  engine                 = var.engine
  engine_version         = var.engine_version
  master_username        = var.username
  database_name          = var.initial_db_name
  vpc_id                 = var.vpc_id
  publicly_accessible    = local.publicly_accessible
  create_db_subnet_group = true
  subnets                = var.subnets
  monitoring_interval    = var.monitoring_interval
  create_monitoring_role = var.create_monitoring_role
  instances              = var.cluster_instance_override

  manage_master_user_password_rotation                   = false
  master_user_password_rotation_automatically_after_days = 30

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  cluster_performance_insights_enabled = false

  autoscaling_enabled               = false
  create_security_group             = true
  security_group_rules              = var.security_group_rules
  db_cluster_parameter_group_family = var.rds_family


  # Multi-AZ
  availability_zones        = var.vpc_availability_zones
  allocated_storage         = var.db_storage_size
  db_cluster_instance_class = var.instance_class
  iops                      = var.iops
  storage_type              = var.storage_type

  cluster_ca_cert_identifier = var.ca_cert_identifier

  skip_final_snapshot = var.skip_final_snapshot
  deletion_protection = var.rds_db_delete_protection
  apply_immediately   = var.apply_immediately
  tags                = var.tags
}
