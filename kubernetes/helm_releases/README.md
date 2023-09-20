## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.7 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.7 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_annotations.change_default_storage_class](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/annotations) | resource |
| [kubernetes_manifest.certbot_prod](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.gp3](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.parameterstore](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.secretmanagerstore](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_secret.external_secret_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service_account.external_secret_irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_ingress_enabled"></a> [alb\_ingress\_enabled](#input\_alb\_ingress\_enabled) | Enable AWS Application Load Balancer Ingress Controller (Specific to EKS Clusters) | `bool` | `false` | no |
| <a name="input_alb_ingress_version"></a> [alb\_ingress\_version](#input\_alb\_ingress\_version) | Helm Chart Version for AWS Application LoadBalancer Controller | `string` | `"1.6.0"` | no |
| <a name="input_alb_resources"></a> [alb\_resources](#input\_alb\_resources) | Resources and Limits for ALB Controller Pod | `map(any)` | <pre>{<br>  "cpu_request": "200m",<br>  "mem_request": "200Mi"<br>}</pre> | no |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Enable Cert Manager In Cluster, Not Needed if Running ALB Ingress | `bool` | `false` | no |
| <a name="input_cert_manager_resources"></a> [cert\_manager\_resources](#input\_cert\_manager\_resources) | Resources and Limits for Cert Manager Pod | `map(any)` | <pre>{<br>  "cpu_limit": "200m",<br>  "cpu_request": "100m",<br>  "mem_limit": "300Mi",<br>  "mem_request": "100Mi"<br>}</pre> | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Helm Chart Version for Cert Manager | `string` | `"v1.8.0"` | no |
| <a name="input_cluster_autoscaler_enabled"></a> [cluster\_autoscaler\_enabled](#input\_cluster\_autoscaler\_enabled) | Enable Cluster Autoscaler in Cluster | `bool` | `false` | no |
| <a name="input_cluster_autoscaler_version"></a> [cluster\_autoscaler\_version](#input\_cluster\_autoscaler\_version) | Helm Chart Version for Cluster Autoscaler | `string` | `"9.27.0"` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name of Kubernetes Cluster. Note. change to Cluster | `string` | n/a | yes |
| <a name="input_enable_cluster_issuer"></a> [enable\_cluster\_issuer](#input\_enable\_cluster\_issuer) | Enable Cluster Issuer for Cert Manager | `bool` | `false` | no |
| <a name="input_enable_gp3_storage"></a> [enable\_gp3\_storage](#input\_enable\_gp3\_storage) | Enable AWS GP3 Storage, Specific to EKS | `bool` | `false` | no |
| <a name="input_external_aws_secret_manager_store_enabled"></a> [external\_aws\_secret\_manager\_store\_enabled](#input\_external\_aws\_secret\_manager\_store\_enabled) | Enable AWS Secret Manager Store Integration | `bool` | `false` | no |
| <a name="input_external_aws_secret_parameter_store_enabled"></a> [external\_aws\_secret\_parameter\_store\_enabled](#input\_external\_aws\_secret\_parameter\_store\_enabled) | Enable AWS Parameter Store Integration | `bool` | `false` | no |
| <a name="input_external_secret_enabled"></a> [external\_secret\_enabled](#input\_external\_secret\_enabled) | Enable External Secrets Helm Release | `bool` | `false` | no |
| <a name="input_external_secret_resources"></a> [external\_secret\_resources](#input\_external\_secret\_resources) | Resources and Limits for External Secrets Pod | `map(any)` | <pre>{<br>  "cpu_request": "100m",<br>  "mem_request": "200Mi"<br>}</pre> | no |
| <a name="input_external_secret_version"></a> [external\_secret\_version](#input\_external\_secret\_version) | Helm Version of External Secrets | `string` | `"0.9.4"` | no |
| <a name="input_external_secrets_namespace"></a> [external\_secrets\_namespace](#input\_external\_secrets\_namespace) | Kubernetes Namespace to Deploy External Secrets | `string` | `"kube-system"` | no |
| <a name="input_metric_server_enabled"></a> [metric\_server\_enabled](#input\_metric\_server\_enabled) | Enable Cluster Metrics Server | `bool` | `true` | no |
| <a name="input_metrics_server_resources"></a> [metrics\_server\_resources](#input\_metrics\_server\_resources) | Resources and Limits for Metrics Server Pod | `map(any)` | <pre>{<br>  "cpu_limit": "200m",<br>  "cpu_request": "100m",<br>  "mem_limit": "300Mi",<br>  "mem_request": "100Mi"<br>}</pre> | no |
| <a name="input_metrics_server_version"></a> [metrics\_server\_version](#input\_metrics\_server\_version) | Helm Chart Version for Metrics Server | `string` | `"6.2.11"` | no |
| <a name="input_nginx_ingress_enabled"></a> [nginx\_ingress\_enabled](#input\_nginx\_ingress\_enabled) | Enable Nginx Ingress Controller Chart | `bool` | `false` | no |
| <a name="input_nginx_ingress_version"></a> [nginx\_ingress\_version](#input\_nginx\_ingress\_version) | Helm Chart Version for Nginx Ingress Controller | `string` | `"4.7.1"` | no |
| <a name="input_service_account_arns"></a> [service\_account\_arns](#input\_service\_account\_arns) | Map of Arns from Service Accounts Module | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to Deploy Loadbalancer for ALB ingress (Specific to AWS) | `string` | n/a | yes |

## Outputs

No outputs.
