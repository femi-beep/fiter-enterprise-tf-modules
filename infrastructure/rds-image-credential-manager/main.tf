locals {
  secret_path = "${var.environment}/${var.database_identifier}"
}

data "aws_caller_identity" "current" {}

module "credential_manager" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.20.2"

  function_name          = "${var.name}-rds-lambda-container"
  description            = "My awesome lambda function with container image by modules/docker-build and ECR repository created by terraform-aws-ecr module"
  vpc_subnet_ids         = var.subnets
  vpc_security_group_ids = var.security_group_ids
  attach_network_policy  = true
  create_package         = false

  ##################
  # Container Image
  ##################
  package_type  = "Image"
  architectures = ["x86_64"]
  timeout       = var.timeout

  environment_variables = {
    ADMIN_SECRET_NAME = var.admin_secret_arn
    DB_HOST           = var.database_host
    ADMIN_DB_NAME     = var.database_admin_db
    DB_IDENTIFIER     = var.database_identifier
    SECRET_PATH       = local.secret_path
  }

  attach_policy_json = true
  policy_json        = data.aws_iam_policy_document.credential_manager_lambda.json
  image_uri          = var.docker_image
}

data "aws_iam_policy_document" "credential_manager_lambda" {
  statement {
    sid    = "AllowSecretsManager"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [var.admin_secret_arn]
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

# Invoke for DB Initialization
resource "aws_lambda_invocation" "postgres_init" {
  count = var.engine == "postgres" ? 1 : 0

  function_name   = module.image_credential_manager.lambda_function_arn
  lifecycle_scope = "CREATE_ONLY"
  input = jsonencode({
    "USERNAME"    = "ignore",
    "DATABASES"   = [],
    "DB_INIT"     = "True"
    "ACCESS_TYPE" = "readonly"
  })

}

# Invoke to create users
resource "aws_lambda_invocation" "db_service" {
  for_each = { for value in var.db_service_users : value.user => value }

  function_name   = module.image_credential_manager.lambda_function_arn
  lifecycle_scope = "CRUD"

  input = jsonencode({
    "USERNAME"    = each.value.user,
    "DATABASES"   = each.value.databases,
    "DB_INIT"     = "False"
    "ACCESS_TYPE" = each.value.access_type
  })
}
