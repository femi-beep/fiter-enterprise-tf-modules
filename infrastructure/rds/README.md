## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_credential_generator"></a> [credential\_generator](#module\_credential\_generator) | terraform-aws-modules/lambda/aws | 2.7.0 |
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | 6.1.1 |
| <a name="module_pymysql_layer"></a> [pymysql\_layer](#module\_pymysql\_layer) | terraform-aws-modules/lambda/aws | 6.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_lambda_invocation.db_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_security_group.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Number of Days to store Automated backup | `number` | `15` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Time duration for backup | `string` | `"03:00-06:00"` | no |
| <a name="input_cloudwatch_logs_names"></a> [cloudwatch\_logs\_names](#input\_cloudwatch\_logs\_names) | Name of log groups which logs to get | `list` | <pre>[<br>  "audit",<br>  "error",<br>  "general"<br>]</pre> | no |
| <a name="input_create_monitoring_role"></a> [create\_monitoring\_role](#input\_create\_monitoring\_role) | Flag to create monitoring role | `bool` | `false` | no |
| <a name="input_db_identifier"></a> [db\_identifier](#input\_db\_identifier) | Name of Database Identifier | `string` | n/a | yes |
| <a name="input_db_service_users"></a> [db\_service\_users](#input\_db\_service\_users) | service user to create for application | `list(string)` | n/a | yes |
| <a name="input_db_storage_size"></a> [db\_storage\_size](#input\_db\_storage\_size) | Size of RDS storage in GB | `number` | `"50"` | no |
| <a name="input_disable_rds_public_access"></a> [disable\_rds\_public\_access](#input\_disable\_rds\_public\_access) | Turn Off Public RDS Access | `bool` | `false` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | `"mysql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Major engine verison of rds | `string` | `"8.0.23"` | no |
| <a name="input_initial_db_name"></a> [initial\_db\_name](#input\_initial\_db\_name) | Name of the db created initially | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Instance type for the cluster eg. db.t2.large | `string` | n/a | yes |
| <a name="input_intra_subnets"></a> [intra\_subnets](#input\_intra\_subnets) | VPC Subnets to Deploy Lambda Non accessible In | `list(string)` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Time at which maintainance should take place | `string` | `"Mon:00:00-Mon:03:00"` | no |
| <a name="input_major_engine_version"></a> [major\_engine\_version](#input\_major\_engine\_version) | Major engine verison of rds | `string` | `"8.0"` | no |
| <a name="input_manage_master_user_password"></a> [manage\_master\_user\_password](#input\_manage\_master\_user\_password) | Set to true to allow RDS to manage the master user password in Secrets Manager | `bool` | `true` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | Interval of monitoring | `number` | `0` | no |
| <a name="input_rds_db_delete_protection"></a> [rds\_db\_delete\_protection](#input\_rds\_db\_delete\_protection) | Whether aws rds/aurora database should have delete protection enabled | `bool` | `true` | no |
| <a name="input_rds_family"></a> [rds\_family](#input\_rds\_family) | RDS family like mysql, aurora with version | `string` | `"mysql8.0"` | no |
| <a name="input_rds_subnets"></a> [rds\_subnets](#input\_rds\_subnets) | VPC Subnets to Deploy RDS In | `list(string)` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Username for the root account of db | `any` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR Block to Allow Connections to the Database | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID From VPC Module | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_secret"></a> [rds\_secret](#output\_rds\_secret) | n/a |
