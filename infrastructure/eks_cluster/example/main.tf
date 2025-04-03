module "vpc" {
  source                            = "git::git@bitbucket.org:revvingadmin/terraform-modules.git//infrastructure//vpc?ref=1.2.0"
  environment                       = "dev"
  customer                          = "revving"
  vpc_cidr                          = "10.0.0.0/16"
  common_tags                       = { "name" = "example" }
  enable_secretmanager_vpc_endpoint = false
}

module "eks" {
  source          = "../"
  environment     = "dev"
  customer        = "revving"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets
  route_table_ids = module.vpc.private_route_table_ids
  common_tags     = { "name" = "example" }
  node_security_group_additional_rules = [
    {
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (use cautiously!)
    },
    {
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
    },
    {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS traffic from anywhere
    },
    {
      protocol        = "all"
      from_port       = 0
      to_port         = 0
      security_groups = ["sg-12345678"] # Allow all traffic within the specified security group
    }
  ]
  aws_auth_roles                 = ["arn:aws:iam::[account_id]:role/[role_name]"]
  aws_auth_users                 = ["iam_user_name"]
  cluster_endpoint_public_access = true
  node_groups_attributes = {
    general-1 = {
      name                    = "example"
      instance_types          = ["t3a.medium"]
      capacity_type           = "ON_DEMAND"
      ami_type                = "AL2_x86_64"
      taints                  = []
      max_size                = 5
      min_size                = 2
      desired_size            = 4
      disk_size               = 50
      subnet_ids              = module.vpc.private_subnets
      pre_bootstrap_user_data = ""
    }
  }
  assume_role_arn = "arn:aws:iam::[account_id]:role/[role_name]"
}
