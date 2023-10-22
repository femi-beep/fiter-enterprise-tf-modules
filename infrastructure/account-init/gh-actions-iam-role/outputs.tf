output "github_iam_role_arn" {
  value = aws_iam_role.github_action_role.arn
}

output "terraform_role_arn" {
  value = aws_iam_role.terraform_role.arn
}