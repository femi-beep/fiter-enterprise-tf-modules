locals {
  account_id = data.aws_caller_identity.current.id
  prefix     = format("%s-%s", var.customer, var.environment)
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
  cluster_name = "${var.customer}-${var.environment}"

  os = lower(data.external.os.result["os"])
  karpenter_auth_roles = [
    {
      rolearn  = module.karpenter.role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes",
      ]
    }
  ]

  auth_roles = [
    for role in var.aws_auth_roles : {
      rolearn  = role
      username = role
      groups   = ["system:masters"]
    }
  ]
  eks_auth_users = [
    for user in var.aws_auth_users :
    {
      userarn  = format("arn:aws:iam::%s:user/%s", local.account_id, user)
      username = user
      groups   = ["system:masters"]
    }
  ]
  eks_auth_roles = concat(local.auth_roles, local.karpenter_auth_roles, local.kube_deploy_user)
}
