data "local_file" "wf_cluster_manager_policy" {
  filename = "${path.module}/wf_cluster_manager_policy.json"
}

module "iam_policy_cluster_manager" {
  count = var.enable_cluster_manager_permissions ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.45.0"

  name        = "wf-ClusterManager${local.resource_suffix}"
  description = "Create and manage EKS Kubernetes clusters"
  policy      = data.local_file.wf_cluster_manager_policy.content
  tags        = var.tags
}

data "local_file" "wf_dns_zone_manager_policy" {
  filename = "${path.module}/wf_dns_zone_manager_policy.json"
}

module "iam_policy_dns_zone_manager" {
  count = var.enable_dns_zone_manager_permissions ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.45.0"

  name        = "wf-DNSZoneManager${local.resource_suffix}"
  description = "Create and manage Route 53 DNS Zones for automated DNS management"
  policy      = data.local_file.wf_dns_zone_manager_policy.content
  tags        = var.tags
}

data "local_file" "wf_network_manager_policy" {
  filename = "${path.module}/wf_network_manager_policy.json"
}

module "iam_policy_network_manager" {
  count = var.enable_network_manager_permissions ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.45.0"

  name        = "wf-NetworkManager${local.resource_suffix}"
  description = "Create and manage VPCs for EKS clusters"
  policy      = data.local_file.wf_network_manager_policy.content
  tags        = var.tags
}

data "local_file" "wf_peering_acceptor_policy" {
  filename = "${path.module}/wf_network_manager_policy.json"
}

module "iam_policy_peering_acceptor" {
  count = var.enable_peering_acceptor_permissions ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.45.0"

  name        = "wf-PeeringAcceptor${local.resource_suffix}"
  description = "Accept peering connections in aws"

  policy = data.local_file.wf_peering_acceptor_policy.content
}

data "local_file" "wf_cloud_info_policy" {
  filename = "${path.module}/wf_cloud_info_policy.json"
}

module "iam_policy_cloud_info" {
  count = var.enable_cloud_info_permissions ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.45.0"

  name        = "wf-CloudInfo${local.resource_suffix}"
  description = "Retrieve pricing and instance type metadata"
  policy      = data.local_file.wf_cloud_info_policy.content
  tags        = var.tags
}