output "cloudaccess" {
  value = module.wayfinder_cloudaccess
}

output "role_arn" {
  description = "ARNs of Cloud Resource IAM role to use in your CloudAccessConfig"
  value       = module.wayfinder_cloudaccess.role_arn
}
