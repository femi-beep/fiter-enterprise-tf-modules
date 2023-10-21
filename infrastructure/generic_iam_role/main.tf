resource "aws_iam_role" "generic_role" {
  name        = "${var.role_name}-${var.customer}-${var.environment}-role"
  description = "Generic IAM Roles"

  tags = var.common_tags

  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.assume_role_arn}"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
EOF
}


data "template_file" "generic_policy" {
  template = file("${path.cwd}/policies/${var.policy_file}")
}

resource "aws_iam_policy" "generic_policy" {
  name        = "${var.role_name}-${var.customer}-${var.environment}-policy"
  description = "Generic Iam Permission Managed by terraform"
  policy      = data.template_file.generic_policy.rendered
}

resource "aws_iam_role_policy_attachment" "generic_policy_attachment" {
  role       = aws_iam_role.generic_role.name
  policy_arn = aws_iam_policy.generic_policy.arn
}


output "argo_client_arn" {
  value = aws_iam_role.generic_role.arn
}
