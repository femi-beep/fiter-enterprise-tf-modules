## Requirements
Get the correct ami to be used from AWS. The region where the VPN will be created matters.
## Providers
| Name | Version |
|--|--|
| [aws](https://registry.terraform.io/providers/hashicorp/aws/latest) | >= 4.47 |

## Modules

## Resources
| Name | Type |
|--|--|
| [random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |resource |
| [aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs
| Name | Description  | Type | Default | Required |
|--|--|--|--|--|
| create_vpn_server |Whether to create the OpenVPN server resources  | bool  | `true` | no |
| vpn_server_username | Admin Username to access server | string  | `"openvpn"` | no |
| vpn_server_port | Port to access server | number | `943` | no |
| vpn_server_instance_type | EC2 Instance type to deploy server | string | `"t2.micro"` | yes |
| vpn_server_ami | AMI to deploy server | string | `n\a` | yes |
| vpn_authorized_access_cidr |CIDR block to allow access to VPN | list(string) | `["0.0.0.0/0"]` | no |
| common_tags | (Required) Resource Tag | map(any) | `n\a` | yes |
|vpn_vpc_id | VPC in which the vpn will be created | string | `n\a` | yes |
| subnet_id | The ID of the subnet where the OpenVPN server will be launched | string | `n\a` | yes |
| ssh_key_path | local path in which the ssh key for the vpn server will be created | string | `n\a` | yes |
| key_name | Name of the SSH key to use for the OpenVPN server | string | `"openvpn_accessserver_key"` | no |
| private_dns_server | value of the private dns server, should be based on vpc cidr | string | `"172.16.0.2"` | no |


## Outputs
| Name | Description |
|--|--|
| openvpn_setup_instructions | Connection details when the VPN server has been created |
| openvpn_admin_password | The admin password for the OpenVPN server |
| openvpn_admin_port | The admin port for the OpenVPN server |
| access_vpn_url | The public URL address of the VPN server admin interface |
| client_vpn_url | The public URL address of the client VPN server interface |
