## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.karpenter_provisioner](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | EKS Cluster Endpoint | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS Cluster Name | `string` | n/a | yes |
| <a name="input_ecr_token_password"></a> [ecr\_token\_password](#input\_ecr\_token\_password) | Elastic Container Registry Token Password for Helm OCI Authentication | `any` | n/a | yes |
| <a name="input_ecr_token_username"></a> [ecr\_token\_username](#input\_ecr\_token\_username) | Elastic Container Registry Token Username for Helm OCI Authentication | `string` | n/a | yes |
| <a name="input_eks_node_security_group_id"></a> [eks\_node\_security\_group\_id](#input\_eks\_node\_security\_group\_id) | EC2 Security Group to Attach to Karpenter Nodes | `string` | n/a | yes |
| <a name="input_instance_profile_name"></a> [instance\_profile\_name](#input\_instance\_profile\_name) | Karpenter Nodes Instance Profile for AWS-AUTH | `string` | n/a | yes |
| <a name="input_karpenter_iam_role"></a> [karpenter\_iam\_role](#input\_karpenter\_iam\_role) | Karpenter IRSA Role | `string` | n/a | yes |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | AWS Subnets to Deploy Karpenter Nodes | `list(string)` | n/a | yes |

## Outputs

No outputs.
