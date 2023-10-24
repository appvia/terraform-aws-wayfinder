locals {
  cluster_manager_role_arns = {
    aws   = var.enable_cluster_manager && var.from_aws ? module.iam_role_cluster_manager[0].iam_role_arn : null
    azure = var.enable_cluster_manager && var.from_azure ? module.iam_role_cluster_manager_azure_oidc[0].iam_role_arn : null
    gcp   = var.enable_cluster_manager && var.from_gcp ? module.iam_role_cluster_manager_google_oidc[0].arn : null
  }

  dns_zone_manager_role_arns = {
    aws   = var.enable_dns_zone_manager && var.from_aws ? module.iam_role_dns_zone_manager[0].iam_role_arn : null
    azure = var.enable_dns_zone_manager && var.from_azure ? module.iam_role_dns_zone_manager_azure_oidc[0].iam_role_arn : null
    gcp   = var.enable_dns_zone_manager && var.from_gcp ? module.iam_role_dns_zone_manager_google_oidc[0].arn : null
  }

  network_manager_role_arns = {
    aws   = var.enable_network_manager && var.from_aws ? module.iam_role_network_manager[0].iam_role_arn : null
    azure = var.enable_network_manager && var.from_azure ? module.iam_role_network_manager_azure_oidc[0].iam_role_arn : null
    gcp   = var.enable_network_manager && var.from_gcp ? module.iam_role_network_manager_google_oidc[0].arn : null
  }

  cloud_info_role_arns = {
    aws   = var.enable_cloud_info && var.from_aws ? module.iam_role_cloud_info[0].iam_role_arn : null
    azure = var.enable_cloud_info && var.from_azure ? module.iam_role_cloud_info_azure_oidc[0].iam_role_arn : null
    gcp   = var.enable_cloud_info && var.from_gcp ? module.iam_role_cloud_info_google_oidc[0].arn : null
  }
}

output "cluster_manager_role_arns" {
  description = "ARNs of Cluster Manager IAM role to use for the ClusterManager spec.permissions[].awsRole in your CloudAccessConfig"
  value       = local.cluster_manager_role_arns
}

output "dns_zone_manager_role_arns" {
  description = "ARNs of DNS Zone Manager IAM role to use for the DNSZoneManager spec.permissions[].awsRole in your CloudAccessConfig"
  value       = local.dns_zone_manager_role_arns
}

output "network_manager_role_arns" {
  description = "ARNs of Network Manager IAM role to use for the NetworkManager spec.permissions[].awsRole in your CloudAccessConfig"
  value       = local.network_manager_role_arns
}

output "cloud_info_role_arns" {
  description = "ARNs of Cloud Info IAM role to use for the CloudInfo spec.permissions[].awsRole in your CloudAccessConfig"
  value       = local.cloud_info_role_arns
}

output "peering_acceptor_role_arn" {
  description = "ARN of Peering Acceptor IAM role to use as spec.permissions[].awsRole on the PeeringAcceptor permission of your cloud access config"
  value       = join("", concat(module.iam_role_peering_acceptor.*.iam_role_arn, module.iam_role_peering_acceptor_azure_oidc.*.iam_role_arn, module.iam_role_peering_acceptor_google_oidc.*.arn))
}

