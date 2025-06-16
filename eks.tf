# tfsec:ignore:aws-eks-no-public-cluster-access
# tfsec:ignore:aws-ec2-no-public-egress-sgr
# tfsec:ignore:aws-eks-no-public-cluster-access-to-cidr
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.0"

  cluster_name    = local.name
  cluster_version = var.cluster_version

  authentication_mode                      = "API"
  access_entries                           = var.access_entries
  cluster_enabled_log_types                = var.cluster_enabled_log_types
  cluster_endpoint_private_access          = true
  cluster_endpoint_public_access           = !var.disable_internet_access
  cluster_endpoint_public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  enable_cluster_creator_admin_permissions = var.access_entries != {} ? false : true
  kms_key_administrators                   = var.kms_key_administrators
  subnet_ids                               = distinct(flatten(values(var.subnet_ids_by_az)))
  tags                                     = local.tags
  vpc_id                                   = var.vpc_id

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
      service_account_role_arn    = module.irsa_ebs_csi_driver.iam_role_arn
    }
  }

  eks_managed_node_group_defaults = {
    iam_role_attach_cni_policy = true
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }

    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${local.name}" : "owned",
    }

    block_device_mappings = {
      # Root volume
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_type           = "gp3"
          encrypted             = true
          kms_key_id            = module.ebs_kms_key.key_arn
          delete_on_termination = true
        }
      }
      xvdb = {
        device_name = "/dev/xvdb"
        ebs = {
          volume_size           = 24
          volume_type           = "gp3"
          iops                  = 3000
          encrypted             = true
          kms_key_id            = module.ebs_kms_key.key_arn
          delete_on_termination = true
        }
      }
    }

    pre_bootstrap_user_data = <<-EOT
      # Wait for second volume to attach before trying to mount paths
      TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
      EC2_INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id)
      DATA_STATE="unknown"
      until [ "$${DATA_STATE}" == "attached" ]; do
        DATA_STATE=$(aws ec2 describe-volumes \
          --region ${data.aws_region.current.name} \
          --filters \
              Name=attachment.instance-id,Values=$${EC2_INSTANCE_ID} \
              Name=attachment.device,Values=/dev/xvdb \
          --query Volumes[].Attachments[].State \
          --output text)
        sleep 5
      done

      # Get the volume ID
      VOLUME_ID=$(aws ec2 describe-volumes \
        --region ${data.aws_region.current.name} \
        --filters \
            Name=attachment.instance-id,Values=$${EC2_INSTANCE_ID} \
            Name=attachment.device,Values=/dev/xvdb \
        --query Volumes[].Attachments[].VolumeId \
        --output text | sed 's/-//')

      # Mount the containerd directories to the 2nd volume
      SECOND_VOL=$(lsblk -o NAME,SERIAL -d |awk -v id="$${VOLUME_ID}" '$2 ~ id {print $1}')
      systemctl stop containerd
      mkfs -t ext4 /dev/$${SECOND_VOL}
      rm -rf /var/lib/containerd/*
      rm -rf /run/containerd/*

      mount /dev/$${SECOND_VOL} /var/lib/containerd/
      mount /dev/$${SECOND_VOL} /run/containerd/
      systemctl start containerd
    EOT

    schedules = var.eks_ng_schedules
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
}

module "ebs_kms_key" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.0"

  aliases            = ["eks/${local.name}/ebs"]
  description        = "Customer managed key to encrypt EKS managed node group volumes"
  key_administrators = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  key_service_roles_for_autoscaling = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    module.eks.cluster_iam_role_arn,
  ]
  tags = local.tags
}

moved {
  from = module.irsa-ebs-csi-driver
  to   = module.irsa_ebs_csi_driver
}

# tflint-ignore: terraform_naming_convention
#trivy:ignore:AVD-AWS-0057
module "irsa_ebs_csi_driver" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.45.0"

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
