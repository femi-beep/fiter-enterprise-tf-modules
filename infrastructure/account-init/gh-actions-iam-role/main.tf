locals {
  repo_url = [for value in var.repo_list : "repo:${value}:*"]
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.github_openidconnect_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.repo_url
    }
  }
}

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

resource "aws_iam_policy" "github_action_policy" {
  name_prefix = "gh-deployment-policy-"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AssumeRole"
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.terraform_role.arn
      },
      {
        Sid    = "AllowStateLock"
        Effect = "Allow",
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        Resource = "arn:aws:dynamodb:*:*:table/${var.table_name}"
      },
      {
        Sid      = "AllowS3State"
        Effect   = "Allow",
        Action   = "s3:ListBucket",
        Resource = "arn:aws:s3:::${var.bucket_name}"
      },
      {
        Sid      = "AllowS3Get"
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })
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

resource "aws_iam_role" "github_action_role" {
  force_detach_policies = true
  name_prefix           = var.deployment_role_name
  assume_role_policy    = data.aws_iam_policy_document.github_actions_assume_role.json
  tags = {
    Name = var.deployment_role_name
  }
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_action_role.name
  policy_arn = aws_iam_policy.github_action_policy.arn
}