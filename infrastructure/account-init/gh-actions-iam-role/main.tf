data "aws_caller_identity" "current" {}

resource "aws_iam_role" "terraform_role" {
  name        = "${var.deployment_role_name}-terraform"
  description = "Terraform Deployment Role"

  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "terraform_policy_attachment" {
  role       = aws_iam_role.terraform_role.name
  policy_arn = aws_iam_policy.terraform_policy.arn
}

resource "aws_iam_policy" "terraform_policy" {
  name_prefix = "tf-deployment-policy-"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid : "AllowSpecifics"
        Action = [
          "lambda:*",
          "apigateway:*",
          "acm:*",
          "ec2:*",
          "rds:*",
          "s3:*",
          "sns:*",
          "states:*",
          "ssm:*",
          "sqs:*",
          "iam:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "cloudwatch:*",
          "cloudfront:*",
          "route53:*",
          "ecr:*",
          "logs:*",
          "ecs:*",
          "application-autoscaling:*",
          "logs:*",
          "events:*",
          "es:*",
          "kms:*",
          "dynamodb:*",
          "apprunner:*",
          "ecr-public:GetAuthorizationToken",
          "eks:*",
          "kms:*",
          "sts:GetServiceBearerToken",
          "secretsmanager:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid : "DenySpecifics"
        Action = [
          "consolidatedbilling:*",
          "invoicing:*",
          "account:*",
          "payments:*",
          "budgets:*",
          "tax:*",
          "ce:*",
          "cur:*",
          "freetier:*",
          "billing:*",
          "config:*",
          "directconnect:*",
          "aws-marketplace:*",
          "aws-marketplace-management:*",
          "ec2:*ReservedInstances*",
        ]
        Effect   = "Deny"
        Resource = "*"
      },
      {
        Sid : "AllowKMS"
        Action = [
          "kms:DescribeKey",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:kms:*:*:key/*"
      }
    ]
  })
}

# Create new github roles
resource "aws_iam_role" "ci_roles" {
  for_each              = var.ci_pipelines_roles
  force_detach_policies = true
  name                  = "${var.deployment_role_name}-${each.key}"
  assume_role_policy    = templatefile("${path.cwd}/${each.value.trustjson}", try(each.value.envvars, {}))
}

resource "aws_iam_policy" "ci_policies" {
  for_each = var.ci_pipelines_roles
  name     = "${var.deployment_role_name}-${each.key}-policy"
  policy   = templatefile("${path.cwd}/${each.value.permissionfile}", try(each.value.envvars, {}))
}

resource "aws_iam_role_policy_attachment" "ci_policies_attachment" {
  for_each   = var.ci_pipelines_roles
  role       = aws_iam_role.ci_roles[each.key].name
  policy_arn = aws_iam_policy.ci_policies[each.key].arn
}