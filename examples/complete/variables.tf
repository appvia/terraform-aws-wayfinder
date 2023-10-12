variable "aws_secretsmanager_name" {
  description = "The name of the AWS Secrets Manager secret to fetch, which contains IDP configuration."
  type        = string
  default     = "wayfinder-secrets"
}

variable "availability_zones" {
  description = "List of availability zones to deploy into."
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "clusterissuer_email" {
  description = "The email address to use for the cert-manager cluster issuer."
  type        = string
}

variable "create_localadmin_user" {
  description = "Whether to create a localadmin user for access to the Wayfinder Portal and API."
  type        = bool
  default     = false
}

variable "disable_internet_access" {
  description = "Whether to disable internet access for EKS and the Wayfinder ingress controller."
  type        = bool
  default     = false
}

variable "disable_local_login" {
  description = "Whether to disable local login for Wayfinder. Note: An IDP must be configured within Wayfinder, otherwise you will not be able to log in."
  type        = bool
  default     = false
}

variable "dns_zone_name" {
  description = "The local DNS zone to use (e.g. wayfinder.example.com)."
  type        = string
}

variable "environment" {
  description = "The environment name we are provisioning."
  type        = string
  default     = "production"
}

variable "idp_provider" {
  description = "The Identity Provider type to configure for Wayfinder (supported: generic, aad)."
  type        = string
  default     = "generic"

  validation {
    condition     = contains(["generic", "aad"], var.idp_provider)
    error_message = "idp_provider must be one of: generic, aad"
  }
}

variable "wayfinder_instance_id" {
  description = "The instance ID to use for Wayfinder."
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(any)
  default     = {}
}

variable "terraform_plan_role_arn" {
  description = "The ARN of the IAM role used for Terraform plan operations."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the Wayfinder VPC."
  type        = string
  default     = "10.0.0.0/21"
}

variable "vpc_private_subnets" {
  description = "List of private subnets in the Wayfinder VPC."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "List of public subnets in the Wayfinder VPC."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}
