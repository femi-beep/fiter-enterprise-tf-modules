module "eks_iam_roles" {
  source                      = "../"
  enable_alb_controller       = false
  enable_argocd               = false
  eks_external_secret_enabled = true
  cluster_oidc_issuer_url     = module.eks.cluster_oidc_issuer_url
  eks_cluster_name            = "example_cluster_name"
  eks_log_bucket              = module.eks.eks_log_bucket_arn
  additional_policies         = {}
}