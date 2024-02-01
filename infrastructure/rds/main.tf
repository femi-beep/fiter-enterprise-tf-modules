locals {
  publicly_accessible = var.disable_rds_public_access ? false : true
  tags = {
    Name    = var.db_identifier
    OwnedBy = "Terraform"
  }
  lambda_layer  = var.engine == "mysql" ? "pymysql.zip" : "psycopg2.zip"
}

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
  for_each          = toset(var.allowed_cidrs)
  security_group_id = aws_security_group.service.id
  cidr_ipv4         = each.value
  from_port         = var.db_port
  ip_protocol       = "tcp"
  to_port           = var.db_port
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.service.id
  cidr_ipv4         = var.vpc_cidr_block
  ip_protocol       = "-1"
}

module "db" {
  source                      = "terraform-aws-modules/rds/aws"
  version                     = "6.1.1"
  identifier                  = var.db_identifier
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  allocated_storage           = var.db_storage_size
  allow_major_version_upgrade = false

  db_name                         = var.initial_db_name
  username                        = var.username
  port                            = var.db_port
  enabled_cloudwatch_logs_exports = var.cloudwatch_logs_names
  vpc_security_group_ids          = [aws_security_group.service.id]

  backup_retention_period = var.backup_retention_period
  maintenance_window      = var.maintenance_window
  backup_window           = var.backup_window


  manage_master_user_password = var.manage_master_user_password
  monitoring_interval         = var.monitoring_interval
  monitoring_role_name        = "${var.db_identifier}RDSMonitoringRole"
  create_monitoring_role      = var.create_monitoring_role
  storage_type                = var.storage_type
  iops                        = var.iops
  storage_encrypted           = var.encrypyt_db_storage
  ca_cert_identifier          = var.ca_cert_identifier

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.rds_subnets #module.vpc.public_subnets

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
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "2.7.0"
  function_name          = "${var.db_identifier}-rds-lambda"
  description            = "Creates Database Users"
  handler                = "index.lambda_handler"
  runtime                = "python3.9"
  source_path            = "${path.module}/lambda/${var.engine}"
  vpc_subnet_ids         = var.intra_subnets
  vpc_security_group_ids = [aws_security_group.service.id]
  attach_network_policy  = true
  timeout                = 60

  layers = [module.pymysql_layer.lambda_layer_arn]

  environment_variables = {
    ADMIN_SECRET_NAME = module.db.db_instance_master_user_secret_arn
    DB_HOST           = module.db.db_instance_address
    ADMIN_DB_NAME     = var.initial_db_name
    DB_IDENTIFIER     = var.db_identifier
  }

  attach_policy_json = true
  # least privilege condition tag should be dynamic
  policy_json = <<-EOT
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "secretsmanager:GetSecretValue",
                    "secretsmanager:DeleteSecret"
                ],
                "Resource": ["*"]
            },
            {
                "Effect": "Allow",
                "Action": [
                    "secretsmanager:CreateSecret",
                    "secretsmanager:ListSecrets",
                    "secretsmanager:DescribeSecret",
                    "secretsmanager:TagResource",
                    "secretsmanager:GetRandomPassword"
                ],
                "Resource": ["*"]
            }
        ]
    }
  EOT

  depends_on = [
    module.db,
    module.pymysql_layer
  ]
  tags = local.tags
}

module "pymysql_layer" {
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "6.0.0"
  create_layer           = true
  layer_name             = "${var.db_identifier}-pysql-layer"
  description            = "PythonMySQL Dependency needed for Lambda Function"
  compatible_runtimes    = ["python3.11"]
  create_package         = false
  local_existing_package = "${path.module}/layers/${local.lambda_layer}"
}

# Invoke for DB Initialization
resource "aws_lambda_invocation" "postgres_init" {
  count         = var.engine == "postgres" ? 1 : 0
  function_name = module.credential_generator.lambda_function_arn
  input = jsonencode({
    "USERNAME"  = "ignore",
    "DATABASES" = [],
    "DB_INIT"   = "True"

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
  for_each      = { for value in var.db_service_users : value.user => value }
  function_name = module.credential_generator.lambda_function_arn

  input = jsonencode({
    "USERNAME"  = each.value.user,
    "DATABASES" = each.value.databases,
    "DB_INIT"   = "False"
  })
  lifecycle_scope = "CRUD"
  depends_on = [
    module.db,
    module.pymysql_layer,
    module.credential_generator
  ]
}

