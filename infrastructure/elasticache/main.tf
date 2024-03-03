#
# Security Group Resources
#
locals {
  enabled = var.enabled
  tags = {
    Name    = var.cache_identifier
    OwnedBy = "Terraform"
  }
  security_group_map    = { for key in var.allowed_cidrs : key.name => key }
  create_security_group = local.enabled && var.create_security_group
  replication_group_id = var.replication_group_id == "" ? var.cache_identifier : var.replication_group_id
}

resource "aws_security_group" "service" {
  count       = local.enabled && var.create_security_group ? 1 : 0
  name        = "${var.cache_identifier}-cache-sg"
  description = var.security_group_description
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "vpc_ingress" {
  count             = local.enabled && var.create_security_group ? 1 : 0
  security_group_id = aws_security_group.service[0].id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = var.cache_port
  ip_protocol       = "tcp"
  to_port           = var.cache_port
  depends_on        = [aws_security_group.service]
}

resource "aws_vpc_security_group_ingress_rule" "access_ingress" {
  for_each          = local.security_group_map
  security_group_id = local.enabled ? aws_security_group.service[0].id : null
  description       = each.value.description
  cidr_ipv4         = each.value.ip
  from_port         = each.value.port == null ? var.cache_port : each.value.port
  ip_protocol       = "tcp"
  to_port           = var.cache_port
  depends_on        = [aws_security_group.service]
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  count       = local.enabled && var.create_security_group ? 1 : 0
  security_group_id = aws_security_group.service[0].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  depends_on        = [aws_security_group.service]
}

locals {
  elasticache_subnet_group_name = var.elasticache_subnet_group_name != "" ? var.elasticache_subnet_group_name : join("", aws_elasticache_subnet_group.default[*].name)

  # if !cluster, then node_count = replica cluster_size, if cluster then node_count = shard*(replica + 1)
  # Why doing this 'The "count" value depends on resource attributes that cannot be determined until apply'. So pre-calculating
  member_clusters_count = (var.cluster_mode_enabled
    ?
    (var.cluster_mode_num_node_groups * (var.cluster_mode_replicas_per_node_group + 1))
    :
    var.cluster_size
  )

  elasticache_member_clusters = local.enabled ? tolist(aws_elasticache_replication_group.default[0].member_clusters) : []

  # The name of the parameter group can’t include "."
  safe_family = replace(var.family, ".", "-")

  parameter_group_name = (
    var.parameter_group_name != null ? var.parameter_group_name : (
      var.create_parameter_group
      ?
      "${var.cache_identifier}-${local.safe_family}" # The name of the new parameter group to be created
      :
      "default.${var.family}" # Default parameter group name created by AWS
    )
  )
}

resource "aws_elasticache_subnet_group" "default" {
  count       = local.enabled && var.elasticache_subnet_group_name == "" && length(var.subnets) > 0 ? 1 : 0
  name        = "${var.cache_identifier}-cache"
  description = "Elasticache subnet group for ${var.cache_identifier}"
  subnet_ids  = var.subnets
  tags        = local.tags
}

resource "aws_elasticache_parameter_group" "default" {
  count       = local.enabled && var.create_parameter_group ? 1 : 0
  name        = local.parameter_group_name
  description = var.parameter_group_description != null ? var.parameter_group_description : "Elasticache parameter group ${local.parameter_group_name}"
  family      = var.family

  dynamic "parameter" {
    for_each = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = tostring(parameter.value.value)
    }
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true

    # Ignore changes to the description since it will try to recreate the resource
    ignore_changes = [
      description,
    ]
  }
}

resource "aws_elasticache_replication_group" "default" {
  count = local.enabled ? 1 : 0

  auth_token                  = var.transit_encryption_enabled ? var.auth_token : null
  replication_group_id        = "${local.replication_group_id}-cache"
  description                 = coalesce(var.description, var.cache_identifier)
  node_type                   = var.instance_type
  num_cache_clusters          = var.cluster_mode_enabled ? null : var.cluster_size
  port                        = var.cache_port
  parameter_group_name        = local.parameter_group_name
  preferred_cache_cluster_azs = length(var.availability_zones) == 0 ? null : [for n in range(0, var.cluster_size) : element(var.availability_zones, n)]
  automatic_failover_enabled  = var.cluster_mode_enabled ? true : var.automatic_failover_enabled
  multi_az_enabled            = var.multi_az_enabled
  subnet_group_name           = local.elasticache_subnet_group_name
  # It would be nice to remove null or duplicate security group IDs, if there are any, using `compact`,
  # but that causes problems, and having duplicates does not seem to cause problems.
  # See https://github.com/hashicorp/terraform/issues/29799
  security_group_ids         = local.create_security_group ? concat(var.associated_security_group_ids, aws_security_group.service[*].id) : var.associated_security_group_ids
  maintenance_window         = var.maintenance_window
  notification_topic_arn     = var.notification_topic_arn
  engine_version             = var.engine_version
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  kms_key_id                 = var.at_rest_encryption_enabled ? var.kms_key_id : null
  snapshot_name              = var.snapshot_name
  snapshot_arns              = var.snapshot_arns
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  final_snapshot_identifier  = var.final_snapshot_identifier
  apply_immediately          = var.apply_immediately
  data_tiering_enabled       = var.data_tiering_enabled
  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration

    content {
      destination      = lookup(log_delivery_configuration.value, "destination", null)
      destination_type = lookup(log_delivery_configuration.value, "destination_type", null)
      log_format       = lookup(log_delivery_configuration.value, "log_format", null)
      log_type         = lookup(log_delivery_configuration.value, "log_type", null)
    }
  }

  tags = local.tags

  num_node_groups         = var.cluster_mode_enabled ? var.cluster_mode_num_node_groups : null
  replicas_per_node_group = var.cluster_mode_enabled ? var.cluster_mode_replicas_per_node_group : null
  user_group_ids          = var.user_group_ids

  # When importing an aws_elasticache_replication_group resource the attribute
  # security_group_names is imported as null. More details:
  # https://github.com/hashicorp/terraform-provider-aws/issues/32835
  lifecycle {
    ignore_changes = [
      security_group_names,
    ]
  }

  depends_on = [
    aws_elasticache_parameter_group.default
  ]
}

#
# CloudWatch Resources
#
resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count               = local.enabled && var.cloudwatch_metric_alarms_enabled ? local.member_clusters_count : 0
  alarm_name          = "${element(local.elasticache_member_clusters, count.index)}-cpu-utilization"
  alarm_description   = "Redis cluster CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "300"
  statistic           = "Average"

  threshold = var.alarm_cpu_threshold_percent

  dimensions = {
    CacheClusterId = element(local.elasticache_member_clusters, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
  depends_on    = [aws_elasticache_replication_group.default]

  tags = local.tags
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count               = local.enabled && var.cloudwatch_metric_alarms_enabled ? local.member_clusters_count : 0
  alarm_name          = "${element(local.elasticache_member_clusters, count.index)}-freeable-memory"
  alarm_description   = "Redis cluster freeable memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"

  threshold = var.alarm_memory_threshold_bytes

  dimensions = {
    CacheClusterId = element(local.elasticache_member_clusters, count.index)
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
  depends_on    = [aws_elasticache_replication_group.default]

  tags = local.tags
}
