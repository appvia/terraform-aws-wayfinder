locals {
  role_arns = {
    aws   = var.from_aws ? module.iam_role[0].iam_role_arn : null
    azure = var.from_azure ? module.iam_role_azure_oidc[0].iam_role_arn : null
    gcp   = var.from_gcp ? module.iam_role_google_oidc[0].arn : null
  }
}

output "role_arn" {
  description = "ARNs of Cloud Resource IAM role to use in your CloudAccessConfig"
  value       = local.role_arns
}
