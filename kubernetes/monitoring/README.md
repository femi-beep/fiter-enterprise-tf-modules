## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.7 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.7 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.loki](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map.log_dashboard](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_secret.grafana_password](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_log_bucket"></a> [eks\_log\_bucket](#input\_eks\_log\_bucket) | AWS Bucket to Send EKS Cluster Logs | `string` | n/a | yes |
| <a name="input_eks_log_region"></a> [eks\_log\_region](#input\_eks\_log\_region) | AWS Region where Log Bucket resides | `string` | n/a | yes |
| <a name="input_eks_log_role"></a> [eks\_log\_role](#input\_eks\_log\_role) | AWS Role ARN with Permission to Upload Logs to S3 Bucket | `string` | n/a | yes |
| <a name="input_eks_log_sa_name"></a> [eks\_log\_sa\_name](#input\_eks\_log\_sa\_name) | Name of Service Account that can Assume Log Role | `string` | `"eks-log-sa"` | no |
| <a name="input_enable_grafana_storage"></a> [enable\_grafana\_storage](#input\_enable\_grafana\_storage) | Enable Grafana Storage | `bool` | `false` | no |
| <a name="input_grafana_resources"></a> [grafana\_resources](#input\_grafana\_resources) | Resources and Limits for Grafana Pod | `map(any)` | <pre>{<br>  "cpu_request": "100m",<br>  "mem_limit": "500Mi",<br>  "mem_request": "300Mi"<br>}</pre> | no |
| <a name="input_grafana_storage_size"></a> [grafana\_storage\_size](#input\_grafana\_storage\_size) | Storage Configuration map of Size and storage Class to use | `string` | `"10Gi"` | no |
| <a name="input_ingress_cert_issuer"></a> [ingress\_cert\_issuer](#input\_ingress\_cert\_issuer) | Cluster Issuer for Cert Manager to be used. Allows for custom | `string` | `"letsencrypt-prod-issuer"` | no |
| <a name="input_ingress_class_name"></a> [ingress\_class\_name](#input\_ingress\_class\_name) | Ingress Class Name for Monitoring Ingress | `string` | `"nginx"` | no |
| <a name="input_ingress_tls_enabled"></a> [ingress\_tls\_enabled](#input\_ingress\_tls\_enabled) | Enable Ingress TLS | `bool` | `true` | no |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace) | Kubernetes Namespace to Deploy Monitoring Components | `string` | `"monitoring"` | no |
| <a name="input_kube_state_resources"></a> [kube\_state\_resources](#input\_kube\_state\_resources) | Request and Limits for Kube-State-Metrics | `map(any)` | <pre>{<br>  "cpu_request": "50m",<br>  "mem_limit": "200Mi",<br>  "mem_request": "50Mi"<br>}</pre> | no |
| <a name="input_loki_helm_version"></a> [loki\_helm\_version](#input\_loki\_helm\_version) | Helm Chart Version for Grafana Loki Stack | `string` | `"2.9.10"` | no |
| <a name="input_loki_resources"></a> [loki\_resources](#input\_loki\_resources) | Request and Limits for Loki Resources | `map(any)` | <pre>{<br>  "cpu_request": "100m",<br>  "mem_request": "200Mi"<br>}</pre> | no |
| <a name="input_monitoring_hostname"></a> [monitoring\_hostname](#input\_monitoring\_hostname) | HostName to Expose Grafana to Internet | `string` | `""` | no |
| <a name="input_monitoring_ingress_enabled"></a> [monitoring\_ingress\_enabled](#input\_monitoring\_ingress\_enabled) | Enable to Expose Grafana Chart to Internet, Requires a HostName | `bool` | `false` | no |
| <a name="input_node_exporter_resources"></a> [node\_exporter\_resources](#input\_node\_exporter\_resources) | Request and Limits for Node Exporter | `map(any)` | <pre>{<br>  "cpu_limit": "200m",<br>  "cpu_request": "50m",<br>  "mem_limit": "200Mi",<br>  "mem_request": "50Mi"<br>}</pre> | no |
| <a name="input_prom_operator_resources"></a> [prom\_operator\_resources](#input\_prom\_operator\_resources) | Request and Limits for Prometheus Operator | `map(any)` | <pre>{<br>  "cpu_request": "50m",<br>  "mem_limit": "200Mi",<br>  "mem_request": "50Mi"<br>}</pre> | no |
| <a name="input_prometheus_helm_version"></a> [prometheus\_helm\_version](#input\_prometheus\_helm\_version) | Helm Chart Version for Kube Prometheus Stack | `string` | `"36.0.2"` | no |
| <a name="input_prometheus_resource_requests"></a> [prometheus\_resource\_requests](#input\_prometheus\_resource\_requests) | Resource Request for Prometheus | `string` | `"400Mi"` | no |
| <a name="input_prometheus_retention_days"></a> [prometheus\_retention\_days](#input\_prometheus\_retention\_days) | Number of Days to Retain Prometheus Metrics | `string` | `"180d"` | no |
| <a name="input_prometheus_storage_size"></a> [prometheus\_storage\_size](#input\_prometheus\_storage\_size) | Size of Prometheus Storage | `string` | `"100Gi"` | no |
| <a name="input_promtail_resources"></a> [promtail\_resources](#input\_promtail\_resources) | Request and Limits for Promtail | `map(any)` | <pre>{<br>  "cpu_request": "100m",<br>  "mem_request": "200Mi"<br>}</pre> | no |
| <a name="input_set_values_prometheus_helm"></a> [set\_values\_prometheus\_helm](#input\_set\_values\_prometheus\_helm) | List of Set Command to Pass to Prometheus Helm Install | `list(any)` | `[]` | no |
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | Slack Channel to Send Alerts Notifications | `string` | `""` | no |
| <a name="input_slack_enabled"></a> [slack\_enabled](#input\_slack\_enabled) | Enable If Slack Hook is Provided. Acts as Destination for Alerts | `bool` | `false` | no |
| <a name="input_slack_hook"></a> [slack\_hook](#input\_slack\_hook) | Slack WebHook for Alerting. To Add Other Sources | `string` | `""` | no |
| <a name="input_storage_class_type"></a> [storage\_class\_type](#input\_storage\_class\_type) | Storage Class to Use for Prometheus Metrics Storage and Grafana | `string` | `"gp3"` | no |

## Outputs

No outputs.
