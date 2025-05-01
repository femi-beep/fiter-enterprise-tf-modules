/*
 * # AWS EKS IAM Role and Policy Terraform Module
 *
 * This module manages AWS IAM roles and policies required for Kubernetes applications running on an [EKS Cluster](https://aws.amazon.com/eks/).
 *
 * It creates IAM roles for various services and assigns the necessary permissions based on predefined policies.
 * Additionally, it allows the use of OIDC for secure access to AWS resources from the Kubernetes service accounts.
 * The module automatically associates the service accounts with the corresponding IAM roles, making it easier to manage permissions at the Kubernetes level.
 * 
 * The IAM policies are generated dynamically based on input policy files and associated with the roles. For additional flexibility, the module supports adding custom policies through the `additional_policies` variable.
 *
 */

module "eks_iam_role" {
  source        = "git::https://github.com/FITER1/fiter-enterprise-tf-modules.git//infrastructure//generic_iam_role?ref=v1.1.7"
  for_each      = local.enabled_service_accounts
  create_policy = true
  role_name     = each.key
  description   = "IAM role for ${each.key} service account"
  role_policy   = each.value.role_policy_json
  assume_policy = data.aws_iam_policy_document.assume_role_with_oidc[each.key].json
  common_tags   = var.tags
}

data "aws_iam_policy_document" "assume_role_with_oidc" {
  for_each = local.enabled_service_accounts

  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.provider_url}"
      ]
    }

    dynamic "condition" {
      for_each = strcontains(each.value.serviceaccount_name, "*") ? [] : [1]
      content {
        test     = "StringEquals"
        variable = "${local.provider_url}:sub"
        values   = ["system:serviceaccount:${each.value.namespace}:${each.value.serviceaccount_name}"]
      }
    }


    dynamic "condition" {
      for_each = strcontains(each.value.serviceaccount_name, "*") ? [1] : []
      content {
        test     = "StringLike"
        variable = "${local.provider_url}:sub"
        values   = ["system:serviceaccount:${each.value.namespace}:${each.value.serviceaccount_name}"]
      }
    }
  }
}
