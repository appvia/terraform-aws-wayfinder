module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.13.0"

  cluster_name    = local.name
  cluster_version = var.cluster_version
  tags            = local.tags

  cluster_enabled_log_types            = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = !var.disable_internet_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  kms_key_administrators               = var.kms_key_administrators
  subnet_ids                           = distinct(flatten(values(var.subnet_ids_by_az)))
  vpc_id                               = var.vpc_id

  cluster_addons = {
    coredns = {
      addon_version               = var.coredns_addon_version
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    kube-proxy = {
      addon_version               = var.kube_proxy_addon_version
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    vpc-cni = {
      addon_version               = var.aws_vpc_cni_addon_version
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      addon_version               = var.aws_ebs_csi_driver_addon_version
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      service_account_role_arn    = module.irsa-ebs-csi-driver.iam_role_arn
    }
  }

  eks_managed_node_group_defaults = {
    iam_role_attach_cni_policy = true

    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${local.name}" : "owned",
    }
  }

  self_managed_node_group_defaults = {
    create_security_group = false
    # enable discovery of autoscaling groups by cluster-autoscaler
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${local.name}" : "owned",
    }
  }

  eks_managed_node_groups = {
    for az, subnet_ids in var.subnet_ids_by_az : az => {
      name                 = "compute-${az}"
      capacity_type        = var.eks_ng_capacity_type
      desired_size         = var.eks_ng_desired_size
      instance_types       = var.eks_ng_instance_types
      launch_template_name = "compute-${az}"
      max_size             = var.eks_ng_maximum_size
      min_size             = var.eks_ng_minimum_size
      subnet_ids           = subnet_ids
    }
  }

  #
  # Security Groups Rules
  #
  cluster_security_group_additional_rules = merge({
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }, var.cluster_security_group_additional_rules)

  node_security_group_additional_rules = merge({
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    allow_ingress_10080 = {
      description                   = "Control plane access 10080"
      protocol                      = "tcp"
      from_port                     = 10080
      to_port                       = 10080
      type                          = "ingress"
      source_cluster_security_group = true
    }
    allow_ingress_10443 = {
      description                   = "Control plane access 10443"
      protocol                      = "tcp"
      from_port                     = 10443
      to_port                       = 10443
      type                          = "ingress"
      source_cluster_security_group = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }, var.node_security_group_additional_rules)

  manage_aws_auth_configmap = true
  aws_auth_roles            = var.eks_aws_auth_roles
}

module "irsa-ebs-csi-driver" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.17.0"

  role_name             = "${local.name}-ebs-csi-driver-irsa"
  attach_ebs_csi_policy = true
  ebs_csi_kms_cmk_ids   = var.ebs_csi_kms_cmk_ids
  tags                  = local.tags

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}
