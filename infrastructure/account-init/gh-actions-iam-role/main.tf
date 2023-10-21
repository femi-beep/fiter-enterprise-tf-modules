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

resource "aws_iam_policy" "deployment_role" {
  name_prefix = "gh-deployment-policy-"
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
          "eks:DescribeCluster",
          "kms:DescribeKey",
          "sts:GetServiceBearerToken"
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

resource "aws_iam_role" "deployment_role" {
  force_detach_policies = true
  name_prefix           = var.deployment_role_name
  assume_role_policy    = data.aws_iam_policy_document.github_actions_assume_role.json
  tags = {
    Name = var.deployment_role_name
  }
}

resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.deployment_role.name
  policy_arn = aws_iam_policy.deployment_role.arn
}