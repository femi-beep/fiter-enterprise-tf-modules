locals {
  eks_log_bucket = "${var.eks_logging_bucketname}-${local.cluster_name}-${local.account_id}"
  account_id     = data.aws_caller_identity.current.id
  prefix         = format("%s-%s", var.customer, var.environment)
  cluster_name   = local.prefix
  args           = var.assume_role_arn == "" ? ["eks", "get-token", "--cluster-name", local.cluster_name] : ["eks", "get-token", "--cluster-name", local.cluster_name, "--role-arn", "${var.assume_role_arn}"]
  interface_endpoints = { for endpoint in var.vpc_interface_endpoints : endpoint => {
    service             = endpoint
    service_type        = "Interface"
    private_dns_enabled = true
    tags = {
      Name = "${endpoint}-vpc-endpoint"
    }
    }
  }

  gateway_endpoint = { for endpoint in var.vpc_gateway_endpoints : endpoint => {
    service      = endpoint
    service_type = "Gateway"
    tags = {
      Name = "${endpoint}-vpc-endpoint"
    }
    route_table_ids = var.route_table_ids
    }
  }

  endpoints = merge(local.interface_endpoints, local.gateway_endpoint)

  node_security_group_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    },
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    ingress_control_plane = {
      description                   = "Control plane to node ephemeral ports"
      protocol                      = "-1"
      from_port                     = 1024
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  node_group_arns = [
    for key, node in module.eks.eks_managed_node_groups : node.iam_role_arn
  ]
}
