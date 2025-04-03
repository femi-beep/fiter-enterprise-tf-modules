output "github_iam_role_arn" {
  value       = { for k, role in aws_iam_role.ci_roles : k => role.arn }
  description = "github iam role arn"
}

output "terraform_role_arn" {
  value       = aws_iam_role.terraform_role.arn
  description = "terraform role arn"
}