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
  default     = "8.0.23"
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

variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain CloudWatch logs for the DB instance"
  type        = number
  default     = 7
}

variable "create_cloudwatch_log_group" {
  description = "Determines whether a CloudWatch log group is created for each enabled_cloudwatch_logs_exports"
  type        = bool
  default     = false
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
  default     = false
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
  validation {
    condition     = contains(["mysql", "postgres"], var.engine)
    error_message = "Object can Contain the Following postgres or mysql"
  }
}

variable "backup_retention_period" {
  type        = number
  default     = 15
  description = "Number of Days to store Automated backup"
}

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  default     = true
  type        = bool
}

variable "db_identifier" {
  type        = string
  description = "Name of Database Identifier"
  validation {
    condition     = can(regex("^[0-9A-Za-z-]+$", var.db_identifier))
    error_message = "Username should only contain numbers, letters and underscores. Only Alphanumeric values and - are allowed"
  }
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

variable "db_service_users" {
  description = "service user to create for application"
  type = list(object({
    user        = string
    access_type = string
    databases   = list(string)
  }))
  validation {
    condition = alltrue([
      for o in var.db_service_users : contains(["readonly", "readwrite"], o.access_type)
    ])
    error_message = "Access_Type can only contains readonly or readwrite. Kindly check your service Users"
  }

  validation {
    condition = alltrue([
      for o in var.db_service_users : can(regex("^[0-9A-Za-z_]+$", o.user))
    ])
    error_message = "Username should only contain numbers, letters and underscores. Only Alphanumeric values are allowed"
  }

  validation {
    condition = alltrue(flatten([
      for o in var.db_service_users : [
        for db_name in o.databases : can(regex("^[0-9A-Za-z_]+$", db_name))
      ]
    ]))
    error_message = "DB Names should only contain numbers, letters and underscores. Only Alphanumeric values are allowed"
  }
}

variable "disable_rds_public_access" {
  description = "Turn Off Public RDS Access"
  type        = bool
  default     = false
}

variable "allowed_cidrs" {
  description = "Allowed Cidrs in the Database"
  type        = list(string)
  default     = []
}

variable "db_port" {
  description = "Database Port to Use"
  type        = number
  default     = 3306
}

variable "encrypyt_db_storage" {
  description = "Enable Storage Encryption"
  type        = bool
  default     = true
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
  default     = "rds-ca-2019"
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

variable "enable_read_replicas" {
  default     = false
  description = "Enable Read Replicas for Database"
  type        = bool
}

variable "read_replicas" {
  description = "List of Read Replicas to create"
  type        = list(string)
  default     = []
}
