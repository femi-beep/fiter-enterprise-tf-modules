module "postgres" {
  source                    = "../../rds"
  db_identifier             = "test-db"
  environment               = "dev"
  username                  = "postgres"
  rds_family                = "postgres16"
  engine                    = "postgres"
  vpc_id                    = module.vpc.vpc_id
  vpc_cidr_block            = module.vpc.vpc_cidr_block
  rds_subnets               = module.vpc.private_subnets
  initial_db_name           = "postgres"
  instance_class            = "db.t3.medium"
  engine_version            = "16.4"
  major_engine_version      = "16"
  disable_rds_public_access = true
  storage_type              = "gp3"
  db_port                   = 5432
  depends_on                = [module.vpc]
}

module "credential_generator_new" {
  source                    = "../"
  name                      = "fineract-db-creator"
  enable_credential_manager = true
  engine                    = "postgres"
  environment               = "dev"
  subnets                   = module.vpc.intra_subnets
  security_group_ids        = [module.postgres.rds_security_group]
  admin_secret_arn          = module.postgres.db_instance_master_user_secret_arn
  database_host             = module.postgres.db_instance_address
  database_admin_db         = "postgres"
  database_identifier       = module.postgres.db_identifier
  region                    = data.aws_region.current.name
  docker_image              = "1345677899.dkr.ecr.us-east-2.amazonaws.com/postgres-db-manager:${data.aws_ecr_image.service_image.image_tags[0]}"
  function_source           = "image"
  db_service_users = [
    {
      user        = "testuser"
      access_type = "readwrite"
      databases   = ["new_db", "db2_new"]
    }
  ]
}

data "aws_ecr_image" "service_image" {
  repository_name = "postgres-db-manager"
  most_recent     = true
}
