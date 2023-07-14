output "cluster_manager_role_arn" {
  description = "The ARN of the Cluster Manager IAM Role"
  value       = module.wayfinder_cloudaccess.cluster_manager_role_arn
}

output "cluster_manager_role_name" {
  description = "The name of the Cluster Manager IAM Role"
  value       = module.wayfinder_cloudaccess.cluster_manager_role_name
}

output "dns_zone_manager_role_arn" {
  description = "The ARN of the DNS Zone Manager IAM Role"
  value       = module.wayfinder_cloudaccess.dns_zone_manager_role_arn
}

output "dns_zone_manager_role_name" {
  description = "The name of the DNS Zone Manager IAM Role"
  value       = module.wayfinder_cloudaccess.dns_zone_manager_role_name
}

output "network_manager_role_arn" {
  description = "The ARN of the Network Manager IAM Role"
  value       = module.wayfinder_cloudaccess.network_manager_role_arn
}

output "network_manager_role_name" {
  description = "The name of the Network Manager IAM Role"
  value       = module.wayfinder_cloudaccess.network_manager_role_name
}
