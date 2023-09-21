variable "availability_zones" {
  description = "List of availability zones to deploy into."
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "clusterissuer_email" {
  description = "The email address to use for the cert-manager cluster issuer."
  type        = string
}

variable "disable_internet_access" {
  description = "Whether to disable internet access for EKS and the Wayfinder ingress controller."
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

variable "wayfinder_instance_id" {
  description = "The instance ID to use for Wayfinder."
  type        = string
}

variable "wayfinder_licence_key" {
  description = "The licence key to use for Wayfinder."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(any)
  default     = {}
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
