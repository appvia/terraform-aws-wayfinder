output "access_key_id" {
  description = "The ID of the created access key"
  value       = aws_iam_access_key.cloudidentity.id
}

output "iam_user_name" {
  description = "The name of the created IAM user"
  value       = aws_iam_user.cloudidentity.name
}

output "iam_user_arn" {
  description = "The ARN of the created IAM user"
  value       = aws_iam_user.cloudidentity.name
}

output "secret_access_key" {
  description = "The value of the secret access key"
  value       = aws_iam_access_key.cloudidentity.secret
  sensitive   = true
}
