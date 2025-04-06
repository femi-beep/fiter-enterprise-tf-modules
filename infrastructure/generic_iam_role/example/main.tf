module "eks_argocd_client" {
  source        = "../"
  create_policy = false
  role_name     = "my-generic-role"
  description   = "IAM role for service account"
  role_policy   = "policy.json"
  assume_policy = "assume_role_json"
  common_tags = {
    Name        = "tag-Name"
    Environment = "production"
    Customer    = "fiter"
  }
}
