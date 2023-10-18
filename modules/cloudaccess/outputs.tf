output "cluster_manager_role_arn" {
  description = "ARN of Cluster Manager IAM role to use as spec.permissions[].awsRole on the ClusterManager permission of your cloud access config"
  value       = join("", concat(module.iam_role_cluster_manager.*.iam_role_arn, module.iam_role_cluster_manager_azure_oidc.*.iam_role_arn, module.iam_role_cluster_manager_google_oidc.*.arn))
}

output "dns_zone_manager_role_arn" {
  description = "ARN of DNS Zone Manager IAM role to use as spec.permissions[].awsRole on the DNSZoneManager permission of your cloud access config"
  value       = join("", concat(module.iam_role_dns_zone_manager.*.iam_role_arn, module.iam_role_dns_zone_manager_azure_oidc.*.iam_role_arn, module.iam_role_dns_zone_manager_google_oidc.*.arn))
}

output "network_manager_role_arn" {
  description = "ARN of Network Manager IAM role to use as spec.permissions[].awsRole on the NetworkManager permission of your cloud access config"
  value       = join("", concat(module.iam_role_network_manager.*.iam_role_arn, module.iam_role_network_manager_azure_oidc.*.iam_role_arn, module.iam_role_network_manager_google_oidc.*.arn))
}

output "cloud_info_role_arn" {
  description = "ARN of Cloud Info IAM role to use as spec.permissions[].awsRole on the CloudInfo permission of your cloud access config"
  value       = join("", concat(module.iam_role_cloud_info.*.iam_role_arn, module.iam_role_cloud_info_azure_oidc.*.iam_role_arn, module.iam_role_cloud_info_google_oidc.*.arn))
}
