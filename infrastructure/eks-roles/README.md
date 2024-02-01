## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_iam_role"></a> [eks\_iam\_role](#module\_eks\_iam\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 4.1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.argo_cd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks_apps_service_account_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.eks_logger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.external_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_ssm_parameter.argocd_private_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.argocd_public_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [tls_private_key.argocdsshkey](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.argo_cd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.eks_logger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.external_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_policies"></a> [additional\_policies](#input\_additional\_policies) | Map of Additional Policies, Extending the module | `map(any)` | `{}` | no |
| <a name="input_alb_k8s_namespace"></a> [alb\_k8s\_namespace](#input\_alb\_k8s\_namespace) | (Optional) Kubernetes Namespace for ALB Controller | `string` | `"kube-system"` | no |
| <a name="input_alb_sa_name"></a> [alb\_sa\_name](#input\_alb\_sa\_name) | (Optional) Kubernetes Service Account for ALB Controller | `string` | `"aws-alb-ingress-controller-sa"` | no |
| <a name="input_argocd_k8s_namespace"></a> [argocd\_k8s\_namespace](#input\_argocd\_k8s\_namespace) | (Optional) Kubernetes Namespace for ArgoCd Controller | `string` | `"argocd"` | no |
| <a name="input_argocd_sa_name"></a> [argocd\_sa\_name](#input\_argocd\_sa\_name) | (Optional) Kubernetes Service Account for ArgoCD Controller | `string` | `"*"` | no |
| <a name="input_ca_k8s_namespace"></a> [ca\_k8s\_namespace](#input\_ca\_k8s\_namespace) | (Optional) Kubernetes Namespace for Cluster Autoscaler Controller | `string` | `"kube-system"` | no |
| <a name="input_ca_sa_name"></a> [ca\_sa\_name](#input\_ca\_sa\_name) | (Optional) Kubernetes Service Account for Cluster Autoscaler Controller | `string` | `"cluster-autoscaler-controller-sa"` | no |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | (Required) OIDC URL for the Kubernetes Cluster | `string` | n/a | yes |
| <a name="input_ebs_k8s_namespace"></a> [ebs\_k8s\_namespace](#input\_ebs\_k8s\_namespace) | (Optional) Kubernetes Namespace for Cluster Autoscaler Controller | `string` | `"kube-system"` | no |
| <a name="input_ebs_sa_name"></a> [ebs\_sa\_name](#input\_ebs\_sa\_name) | (Optional) Kubernetes Service Account for EBS CSI Controller | `string` | `"ebs-csi-controller-sa"` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | (Required) EKS Cluster Name | `string` | n/a | yes |
| <a name="input_eks_external_secret_enabled"></a> [eks\_external\_secret\_enabled](#input\_eks\_external\_secret\_enabled) | Enable External Secrets IAM Role | `bool` | `true` | no |
| <a name="input_eks_log_bucket"></a> [eks\_log\_bucket](#input\_eks\_log\_bucket) | Bucket ARN to send EKS Logs | `string` | `""` | no |
| <a name="input_enable_alb_controller"></a> [enable\_alb\_controller](#input\_enable\_alb\_controller) | (Optional) Enable Creation of ALB Controller Role | `bool` | `false` | no |
| <a name="input_enable_argocd"></a> [enable\_argocd](#input\_enable\_argocd) | (Optional) Enable Creation of ArgoCD Role | `bool` | `false` | no |
| <a name="input_enable_cluster_autoscaler"></a> [enable\_cluster\_autoscaler](#input\_enable\_cluster\_autoscaler) | (Optional) Enable Creation of Cluster Autoscaler Role | `bool` | `false` | no |
| <a name="input_enable_eks_log_bucket"></a> [enable\_eks\_log\_bucket](#input\_enable\_eks\_log\_bucket) | Enabled EKS Bucket Log Role | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_dns](#input\_enable\_external\_dns) | (Optional) Enable Creation of External DNS Role | `bool` | `false` | no |
| <a name="input_extDNS_k8s_namespace"></a> [extDNS\_k8s\_namespace](#input\_extDNS\_k8s\_namespace) | (Optional) Kubernetes Namespace for External DNS Controller | `string` | `"kube-system"` | no |
| <a name="input_extDNS_sa_name"></a> [extDNS\_sa\_name](#input\_extDNS\_sa\_name) | (Optional) Kubernetes Service Account for External DNS Controller | `string` | `"external-dns-sa"` | no |
| <a name="input_external_secret_sa_name"></a> [external\_secret\_sa\_name](#input\_external\_secret\_sa\_name) | Service Account Name for External Secrets | `string` | `"*"` | no |
| <a name="input_monitoring_namespace"></a> [monitoring\_namespace](#input\_monitoring\_namespace) | Monitoring Namespace where Log System is deployed | `string` | `"monitoring"` | no |
| <a name="input_monitoring_sa_name"></a> [monitoring\_sa\_name](#input\_monitoring\_sa\_name) | Service Account Name for EKS logs | `string` | `"eks-log-sa"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | n/a |
