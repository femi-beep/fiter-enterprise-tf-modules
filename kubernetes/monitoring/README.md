## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.loki](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map.log_dashboard](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_log_bucket"></a> [eks\_log\_bucket](#input\_eks\_log\_bucket) | AWS Bucket to Send EKS Cluster Logs | `string` | n/a | yes |
| <a name="input_eks_log_region"></a> [eks\_log\_region](#input\_eks\_log\_region) | AWS Region where Log Bucket resides | `string` | n/a | yes |
| <a name="input_eks_log_role"></a> [eks\_log\_role](#input\_eks\_log\_role) | AWS Role ARN with Permission to Upload Logs to S3 Bucket | `string` | n/a | yes |
| <a name="input_eks_log_sa_name"></a> [eks\_log\_sa\_name](#input\_eks\_log\_sa\_name) | Name of Service Account that can Assume Log Role | `string` | `"eks-log-sa"` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes Namespace to Deploy Monitoring Components | `string` | `"monitoring"` | no |
| <a name="input_loki_helm_version"></a> [loki\_helm\_version](#input\_loki\_helm\_version) | Helm Chart Version for Grafana Loki Stack | `string` | `"2.9.10"` | no |
| <a name="input_monitoring_hostname"></a> [monitoring\_hostname](#input\_monitoring\_hostname) | HostName to Expose Grafana to Internet | `string` | `""` | no |
| <a name="input_monitoring_ingress_enabled"></a> [monitoring\_ingress\_enabled](#input\_monitoring\_ingress\_enabled) | Enable to Expose Grafana Chart to Internet, Requires a HostName | `bool` | `false` | no |
| <a name="input_prometheus_helm_version"></a> [prometheus\_helm\_version](#input\_prometheus\_helm\_version) | Helm Chart Version for Kube Prometheus Stack | `string` | `"36.0.2"` | no |
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | Slack Channel to Send Alerts Notifications | `string` | `""` | no |
| <a name="input_slack_enabled"></a> [slack\_enabled](#input\_slack\_enabled) | Enable If Slack Hook is Provided. Acts as Destination for Alerts | `bool` | `false` | no |
| <a name="input_slack_hook"></a> [slack\_hook](#input\_slack\_hook) | Slack WebHook for Alerting. To Add Other Sources | `string` | `""` | no |
| <a name="input_storage_class_type"></a> [storage\_class\_type](#input\_storage\_class\_type) | Storage Class to Use for Prometheus Metrics Storage | `string` | `"gp3"` | no |

## Outputs

No outputs.
