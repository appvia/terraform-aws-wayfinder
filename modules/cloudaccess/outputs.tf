output "cluster_manager_role_arn" {
  description = "ARN of Cluster Manager IAM role to use as spec.permissions[].awsRole on the ClusterManager permission of your cloud access config"
  value = [
    var.enable_cluster_manager && var.from_aws ? module.iam_role_cluster_manager[0].iam_role_arn : null,
    var.enable_cluster_manager && var.from_azure ? module.iam_role_cluster_manager_azure_oidc[0].iam_role_arn : null,
    var.enable_cluster_manager && var.from_gcp ? module.iam_role_cluster_manager_google_oidc[0].arn : null,
  ]
}

output "dns_zone_manager_role_arn" {
  description = "ARN of DNS Zone Manager IAM role to use as spec.permissions[].awsRole on the DNSZoneManager permission of your cloud access config"
  value = [
    var.enable_dns_zone_manager && var.from_aws ? module.iam_role_dns_zone_manager[0].iam_role_arn : null,
    var.enable_dns_zone_manager && var.from_azure ? module.iam_role_dns_zone_manager_azure_oidc[0].iam_role_arn : null,
    var.enable_dns_zone_manager && var.from_gcp ? module.iam_role_dns_zone_manager_google_oidc[0].arn : null,
  ]
}

output "network_manager_role_arn" {
  description = "ARN of Network Manager IAM role to use as spec.permissions[].awsRole on the NetworkManager permission of your cloud access config"
  value = [
    var.enable_network_manager && var.from_aws ? module.iam_role_network_manager[0].iam_role_arn : null,
    var.enable_network_manager && var.from_azure ? module.iam_role_network_manager_azure_oidc[0].iam_role_arn : null,
    var.enable_network_manager && var.from_gcp ? module.iam_role_network_manager_google_oidc[0].arn : null,
  ]
}

output "cloud_info_role_arn" {
  description = "ARN of Cloud Info IAM role to use as spec.permissions[].awsRole on the CloudInfo permission of your cloud access config"
  value = [
    var.enable_cloud_info && var.from_aws ? module.iam_role_cloud_info[0].iam_role_arn : null,
    var.enable_cloud_info && var.from_azure ? module.iam_role_cloud_info_azure_oidc[0].iam_role_arn : null,
    var.enable_cloud_info && var.from_gcp ? module.iam_role_cloud_info_google_oidc[0].arn : null,
  ]
}
