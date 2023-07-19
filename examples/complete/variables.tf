variable "aws_secretsmanager_name" {
  description = "The name of the AWS Secrets Manager secret to fetch, which contains IDP configuration"
  type        = string
  default     = "wayfinder-secrets"
}

variable "availability_zones" {
  description = "List of availability zones to deploy into"
  type        = list(string)
}

variable "clusterissuer_email" {
  description = "The email address to use for the cert-manager cluster issuer"
  type        = string
}

variable "disable_internet_access" {
  description = "Whether to disable internet access for EKS and the Wayfinder ingress controller"
  type        = bool
  default     = false
}

variable "dns_zone_name" {
  description = "The local DNS zone to use (e.g. wayfinder.example.com)"
  type        = string
}

variable "environment" {
  description = "The environment name we are provisioning"
  type        = string
  default     = "production"
}

variable "idp_provider" {
  description = "The Identity Provider type to configure for Wayfinder (supported: generic, aad)"
  type        = string
  default     = "generic"

  validation {
    condition     = contains(["generic", "aad"], var.idp_provider)
    error_message = "idp_provider must be one of: generic, aad"
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(any)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the Wayfinder VPC"
  type        = string
}

variable "vpc_private_subnets" {
  description = "List of private subnets in the Wayfinder VPC"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "List of public subnets in the Wayfinder VPC"
  type        = list(string)
}
