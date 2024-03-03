variable "enabled" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating any resources"
}

variable "cache_identifier" {
  type        = string
  description = "Name of Elasticache Identifier"
  validation {
    condition     = can(regex("^[0-9A-Za-z-]+$", var.cache_identifier))
    error_message = "Username should only contain numbers, letters and underscores. Only Alphanumeric values and - are allowed"
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}


variable "vpc_cidr_block" {
  description = "VPC CIDR Block to Allow Connections to the Database"
  type        = string
}

variable "cache_port" {
  description = "Cache Port to Use"
  type        = number
  default     = 6379
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

variable "elasticache_subnet_group_name" {
  type        = string
  description = "Subnet group name for the ElastiCache instance"
  default     = ""
}

variable "cluster_mode_enabled" {
  type        = bool
  description = "Flag to enable/disable creation of a native redis cluster. `automatic_failover_enabled` must be set to `true`. Only 1 `cluster_mode` block is allowed"
  default     = false
}

variable "cluster_mode_num_node_groups" {
  type        = number
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications"
  default     = 0
}

variable "cluster_mode_replicas_per_node_group" {
  type        = number
  description = "Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will force a new resource"
  default     = 0
}

variable "cluster_size" {
  type        = number
  default     = 1
  description = "Number of nodes in cluster. *Ignored when `cluster_mode_enabled` == `true`*"
}

variable "family" {
  type        = string
  default     = "redis4.0"
  description = "Redis family"
}

variable "parameter_group_name" {
  type        = string
  default     = null
  description = "Override the default parameter group name"
}

variable "create_parameter_group" {
  type        = bool
  default     = true
  description = "Whether new parameter group should be created. Set to false if you want to use existing parameter group"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
  default     = []
}

variable "parameter_group_description" {
  type        = string
  default     = null
  description = "Managed by Terraform"
}

variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
}


variable "transit_encryption_enabled" {
  type        = bool
  default     = true
  description = <<-EOT
    Set `true` to enable encryption in transit. Forced `true` if `var.auth_token` is set.
    If this is enabled, use the [following guide](https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/in-transit-encryption.html#connect-tls) to access redis.
    EOT
}

variable "auth_token" {
  type        = string
  description = "Auth token for password protecting redis, `transit_encryption_enabled` must be set to `true`. Password must be longer than 16 chars"
  default     = null
}

variable "replication_group_id" {
  type        = string
  description = "Replication group ID with the following constraints: \nA name must contain from 1 to 20 alphanumeric characters or hyphens. \n The first character must be a letter. \n A name cannot end with a hyphen or contain two consecutive hyphens."
  default     = ""
}

variable "description" {
  type        = string
  default     = null
  description = "Description of elasticache replication group"
}

variable "instance_type" {
  type        = string
  default     = "cache.t2.micro"
  description = "Elastic cache instance type"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zone IDs"
  default     = []
}

variable "automatic_failover_enabled" {
  type        = bool
  default     = false
  description = "Automatic failover (Not available for T1/T2 instances)"
}

variable "multi_az_enabled" {
  type        = bool
  default     = false
  description = "Multi AZ (Automatic Failover must also be enabled.  If Cluster Mode is enabled, Multi AZ is on by default, and this setting is ignored)"
}

variable "create_security_group" {
  type        = bool
  default     = true
  description = "Set `true` to create and configure a new security group. If false, `associated_security_group_ids` must be provided."
}

variable "maintenance_window" {
  type        = string
  default     = "wed:03:00-wed:04:00"
  description = "Maintenance window"
}

variable "notification_topic_arn" {
  type        = string
  default     = ""
  description = "Notification topic arn"
}

variable "engine_version" {
  type        = string
  default     = "4.0.10"
  description = "Redis engine version"
}

variable "at_rest_encryption_enabled" {
  type        = bool
  default     = false
  description = "Enable encryption at rest"
}

variable "kms_key_id" {
  type        = string
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. `at_rest_encryption_enabled` must be set to `true`"
  default     = null
}

variable "snapshot_name" {
  type        = string
  description = "The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource."
  default     = null
}

variable "snapshot_arns" {
  type        = list(string)
  description = "A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. Example: arn:aws:s3:::my_bucket/snapshot1.rdb"
  default     = []
}

variable "snapshot_window" {
  type        = string
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster."
  default     = "06:30-07:30"
}

variable "snapshot_retention_limit" {
  type        = number
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them."
  default     = 0
}

variable "final_snapshot_identifier" {
  type        = string
  description = "The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made."
  default     = null
}

variable "apply_immediately" {
  type        = bool
  default     = true
  description = "Apply changes immediately"
}

variable "data_tiering_enabled" {
  type        = bool
  default     = false
  description = "Enables data tiering. Data tiering is only supported for replication groups using the r6gd node type."
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = null
  description = "Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported if the engine version is 6 or higher."
}

variable "log_delivery_configuration" {
  type        = list(map(any))
  default     = []
  description = "The log_delivery_configuration block allows the streaming of Redis SLOWLOG or Redis Engine Log to CloudWatch Logs or Kinesis Data Firehose. Max of 2 blocks."
}

variable "user_group_ids" {
  type        = list(string)
  default     = null
  description = "User Group ID to associate with the replication group"
}

variable "cloudwatch_metric_alarms_enabled" {
  type        = bool
  description = "Boolean flag to enable/disable CloudWatch metrics alarms"
  default     = false
}

variable "alarm_cpu_threshold_percent" {
  type        = number
  default     = 75
  description = "CPU threshold alarm level"
}

variable "alarm_actions" {
  type        = list(string)
  description = "Alarm action list"
  default     = []
}

variable "ok_actions" {
  type        = list(string)
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Number (ARN)"
  default     = []
}

variable "alarm_memory_threshold_bytes" {
  # 10MB
  type        = number
  default     = 10000000
  description = "Ram threshold alarm level"
}

variable "associated_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IDs of Security Groups to associate the created resource with, in addition to the created security group.
    These security groups will not be modified and, if `create_security_group` is `false`, must provide all the required access.
    EOT
}

variable "security_group_description" {
  type = string
  default = ""
  description = "Optional String for describing the created security group"
}