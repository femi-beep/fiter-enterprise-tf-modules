/**
 * # AWS RDS Terraform Module
 *
 * This module provisions an AWS [RDS Database Instance](https://aws.amazon.com/rds/) along with supporting resources such as Security Groups, Read Replicas, and IAM Lambda integration.
 *
 * Resources created include:
 * - RDS instances with customizable configurations.
 * - Security Groups with ingress and egress rules.
 * - Read Replicas to enhance performance.
 * - Lambda functions for credential management and database initialization.
 * - IAM roles and policies for secure access.
 *
 * The module ensures seamless database access through integration with AWS Secrets Manager and Session Manager for secure credential storage and retrieval.
 *
*/


locals {
  secret_path               = "${var.environment}/${var.db_identifier}"
  enable_credential_manager = var.replicate_source_db == null && var.snapshot_name == null && var.enable_credential_manager
}

data "aws_caller_identity" "current" {}

resource "aws_security_group" "service" {
  name        = "${var.db_identifier}-rds-sg"
  description = "Allow inbound traffic to RDS"
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "vpc_ingress" {
  security_group_id = aws_security_group.service.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = var.db_port
  ip_protocol       = "tcp"
  to_port           = var.db_port
}

resource "aws_vpc_security_group_ingress_rule" "access_ingress" {
  for_each          = local.security_group_map
  security_group_id = aws_security_group.service.id
  description       = each.value.description
  cidr_ipv4         = each.value.ip
  from_port         = each.value.port == null ? var.db_port : each.value.port
  ip_protocol       = "tcp"
  to_port           = var.db_port
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.service.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

module "db" {
  source                      = "terraform-aws-modules/rds/aws"
  version                     = "6.10.0"
  identifier                  = var.db_identifier
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  allocated_storage           = var.db_storage_size
  allow_major_version_upgrade = false

  db_name                                = var.initial_db_name
  username                               = var.username
  port                                   = var.db_port
  enabled_cloudwatch_logs_exports        = var.cloudwatch_logs_names
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  create_cloudwatch_log_group            = var.create_cloudwatch_log_group
  vpc_security_group_ids                 = [aws_security_group.service.id]

  backup_retention_period = var.backup_retention_period
  maintenance_window      = var.maintenance_window
  backup_window           = var.backup_window

  snapshot_identifier         = var.snapshot_name
  manage_master_user_password = local.enable_credential_manager
  monitoring_interval         = var.monitoring_interval
  monitoring_role_name        = "${var.db_identifier}RDSMonitoringRole"
  create_monitoring_role      = var.create_monitoring_role
  storage_type                = var.storage_type
  iops                        = var.iops
  storage_encrypted           = var.encrypt_db_storage
  ca_cert_identifier          = var.ca_cert_identifier
  replicate_source_db         = var.replicate_source_db

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  apply_immediately                     = var.apply_immediately

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.rds_subnets

  # DB parameter group
  family = var.rds_family

  # DB option group
  major_engine_version = var.major_engine_version

  skip_final_snapshot = true
  # Database Deletion Protection change on production
  deletion_protection = var.rds_db_delete_protection

  publicly_accessible = local.publicly_accessible # set to false to enforce it is not publicly accessible

  tags = local.tags
}


module "credential_generator" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "2.7.0"

  create                 = var.replicate_source_db == null && var.snapshot_name == null
  function_name          = "${var.db_identifier}-rds-lambda"
  description            = "Creates Database Users"
  handler                = "index.lambda_handler"
  runtime                = "python3.9"
  source_path            = "${path.cwd}/lambdas/${var.engine}"
  vpc_subnet_ids         = local.publicly_accessible ? var.rds_subnets : var.intra_subnets
  vpc_security_group_ids = [aws_security_group.service.id]
  attach_network_policy  = true
  timeout                = 60

  layers = [module.pymysql_layer.lambda_layer_arn]

  environment_variables = {
    ADMIN_SECRET_NAME = module.db.db_instance_master_user_secret_arn
    DB_HOST           = module.db.db_instance_address
    ADMIN_DB_NAME     = var.initial_db_name
    DB_IDENTIFIER     = var.db_identifier
    SECRET_PATH       = local.secret_path
  }

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.credential_manager_lambda.json

  depends_on = [
    module.db,
    module.pymysql_layer
  ]
  tags = local.tags
}

data "aws_iam_policy_document" "credential_manager_lambda" {
  statement {
    sid    = "AllowSecretsManager"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [module.db.db_instance_master_user_secret_arn]
  }

  statement {
    sid    = "AllowSecretsManagerCreate"
    effect = "Allow"
    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:ListSecrets",
      "secretsmanager:DescribeSecret",
      "secretsmanager:TagResource",
      "secretsmanager:GetRandomPassword"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "GetSecretUser"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DeleteSecret"
    ]
    resources = ["arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${local.secret_path}/*"]
  }
}

module "pymysql_layer" {
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "6.0.0"
  create                 = local.enable_credential_manager
  create_layer           = local.enable_credential_manager
  layer_name             = "${var.db_identifier}-pysql-layer"
  description            = "PythonMySQL Dependency needed for Lambda Function"
  compatible_runtimes    = ["python3.11"]
  create_package         = false
  local_existing_package = "${path.module}/layers/${local.lambda_layer}"
}

# Invoke for DB Initialization
resource "aws_lambda_invocation" "postgres_init" {
  count         = var.engine == "postgres" && local.enable_credential_manager ? 1 : 0
  function_name = module.credential_generator.lambda_function_arn
  input = jsonencode({
    "USERNAME"    = "ignore",
    "DATABASES"   = [],
    "DB_INIT"     = "True"
    "ACCESS_TYPE" = "readonly"
  })

  lifecycle_scope = "CREATE_ONLY"
  depends_on = [
    module.db,
    module.pymysql_layer,
    module.credential_generator
  ]
}

# Invoke to create users
resource "aws_lambda_invocation" "db_service" {
  for_each = local.enable_credential_manager ? { for value in var.db_service_users : value.user => value } : {}

  function_name = module.credential_generator.lambda_function_arn

  input = jsonencode({
    "USERNAME"    = each.value.user,
    "DATABASES"   = each.value.databases,
    "DB_INIT"     = "False"
    "ACCESS_TYPE" = each.value.access_type
  })

  lifecycle_scope = "CRUD"
  depends_on = [
    module.db,
    module.pymysql_layer,
    module.credential_generator
  ]
}
