locals {
  publicly_accessible = var.disable_rds_public_access ? false : true
  tags = {
    Name    = var.db_identifier
    OwnedBy = "Terraform"
  }
  security_group_map = { for key in var.allowed_cidrs : key.name => key }
  lambda_layer       = var.engine == "mysql" ? "pymysql.zip" : "psycopg2.zip"
}