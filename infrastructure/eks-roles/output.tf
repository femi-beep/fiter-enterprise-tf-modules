output "iam_role_arn" {
  value = {for k, role in module.eks_iam_role: k => role.iam_role_arn}
}

# output "iam_role_arn" {
#   value = {
#     for k, role in module.eks_iam_role: 
#     k => {
#     "role" = role.iam_role_arn
#     "sa"   = local.eks_roles[k]["serviceaccount_name"]
#     }
#   }
# }