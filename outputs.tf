output "cluster_endpoint" {
  description = "The endpoint for the Wayfinder EKS Kubernetes API."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data for the Wayfinder EKS cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "The name of the Wayfinder EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_oidc_provider_arn" {
  description = "The ARN of the OIDC provider for the Wayfinder EKS cluster."
  value       = module.eks.oidc_provider_arn
}

output "wayfinder_api_url" {
  description = "The URL for the Wayfinder API."
  value       = "https://${var.wayfinder_domain_name_api}"
}

output "wayfinder_ui_url" {
  description = "The URL for the Wayfinder UI."
  value       = "https://${var.wayfinder_domain_name_ui}"
}

output "wayfinder_instance_id" {
  description = "The unique identifier for the Wayfinder instance."
  value       = var.wayfinder_instance_id
}

output "wayfinder_iam_role_arn" {
  description = "The ARN of the IAM role used by Wayfinder."
  value       = module.wayfinder_irsa_role.iam_role_arn
}

output "wayfinder_admin_username" {
  description = "The username for the Wayfinder local admin user."
  value       = var.enable_k8s_resources && var.create_localadmin_user ? "localadmin" : null
}

output "wayfinder_admin_password" {
  description = "The password for the Wayfinder local admin user."
  value       = var.create_localadmin_user ? random_password.wayfinder_localadmin[0].result : null
  sensitive   = true
}
