variable "rds_family" {
  description = "RDS family like mysql, aurora with version"
  default     = "mysql8.0"
}

variable "major_engine_version" {
  description = "Major engine verison of rds"
  default     = "8.0"
  type        = string
}

variable "username" {
  description = "Username for the root account of db"
  sensitive   = true
}

variable "engine_version" {
  description = "Major engine verison of rds"
  default     = "8.0.33"
  type        = string
}

variable "initial_db_name" {
  description = "Name of the db created initially"
  type        = string
}

variable "db_storage_size" {
  description = "Size of RDS storage in GB"
  default     = "50"
  type        = number
}
variable "instance_class" {
  description = "Instance type for the cluster eg. db.t2.large"
  type        = string
}

variable "rds_db_delete_protection" {
  type        = bool
  description = "Whether aws rds/aurora database should have delete protection enabled"
  default     = true
}

variable "cloudwatch_logs_names" {
  description = "Name of log groups which logs to get"
  default     = ["audit", "error", "general"]
}

variable "maintenance_window" {
  description = "Time at which maintainance should take place"
  default     = "Mon:00:00-Mon:03:00"
  type        = string
}

variable "backup_window" {
  description = "Time duration for backup"
  default     = "03:00-06:00"
}

variable "create_monitoring_role" {
  description = "Flag to create monitoring role"
  default     = true
  type        = bool
}


variable "monitoring_interval" {
  description = "Interval of monitoring"
  type        = number
  default     = 0
}

variable "engine" {
  description = "The database engine to use"
  default     = "mysql"
}

variable "backup_retention_period" {
  type        = number
  default     = 15
  description = "Number of Days to store Automated backup"
}

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  default     = false
  type        = bool
}

variable "db_identifier" {
  type        = string
  description = "Name of Database Identifier"
}

variable "vpc_id" {
  description = "VPC ID From VPC Module"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block to Allow Connections to the Database"
  type        = string
}

variable "rds_subnets" {
  description = "VPC Subnets to Deploy RDS In"
  type        = list(string)
}

variable "intra_subnets" {
  description = "VPC Subnets to Deploy Lambda Non accessible In"
  type        = list(string)
}

variable "disable_rds_public_access" {
  description = "Turn Off Public RDS Access"
  type        = bool
  default     = false
}

variable "snapshot_db_name" {
  description = "Name of DB to be snapshot"
  type        = string
}

variable "allowed_cidrs" {
  description = "Allowed Cidrs in the Database"
  type = list(object({
    name        = string
    ip          = string
    description = string
    port        = optional(string, null)
  }))
  default = []
}

variable "db_port" {
  description = "Database Port to Use"
  type        = number
  default     = 3306
}

variable "encrypyt_db_storage" {
  description = "Enable Storage Encryption"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "Storage Type"
  default     = null
  type        = string
}

variable "iops" {
  type        = number
  description = "IOPS to Provision"
  default     = null
}

variable "ca_cert_identifier" {
  default     = "rds-ca-rsa2048-g1"
  description = "See Certificate Authority on RDS Page"
  type        = string
}

variable "performance_insights_enabled" {
  default     = false
  description = "Enable Performance Insights"
  type        = bool
}

variable "performance_insights_retention_period" {
  default     = 0
  description = "Performance Insights Retention days"
  type        = number
}
