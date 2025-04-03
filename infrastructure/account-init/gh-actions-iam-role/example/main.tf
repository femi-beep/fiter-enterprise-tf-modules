data "aws_caller_identity" "current" {}

module "gh_actions_iam_role" {
  source                   = "../"
  deployment_role_name     = "example_deployment_role_name"
  github_openidconnect_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
  bucket_name              = "example_bucket"
  table_name               = "example_table"
  ci_pipelines_roles       = "example_ci_pipelines_roles"
}


