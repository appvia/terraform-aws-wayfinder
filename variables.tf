variable "aws_secretsmanager_name" {
  description = "The name of the AWS Secrets Manager secret to use for Wayfinder. Must already exist and contain: 'licenseKey', 'idpClientId', 'idpClientSecret', 'idpServerUrl'"
  type        = string
  default     = "wayfinder-secrets"
}

variable "clusterissuer_email" {
  description = "The email address to use for the cert-manager cluster issuer"
  type        = string
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source"
  type        = any
  default     = {}
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

variable "eks_ng_capacity_type" {
  description = "The capacity type to use for the EKS managed node group"
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_ng_desired_size" {
  description = "The desired size to use for the EKS managed node group"
  type        = number
  default     = 2
}

variable "eks_ng_instance_types" {
  description = "The instance types to use for the EKS managed node group"
  type        = list(string)
  default     = ["t3.xlarge"]
}

variable "eks_ng_minimum_size" {
  description = "The minimum size to use for the EKS managed node group"
  type        = number
  default     = 2
}

variable "environment" {
  description = "The environment name we are provisioning"
  type        = string
  default     = "production"
}

variable "kms_key_administrators" {
  description = "A list of IAM ARNs for EKS key administrators. If no value is provided, the current caller identity is used to ensure at least one key admin is available"
  type        = list(string)
  default     = []
}

variable "node_security_group_additional_rules" {
  description = "List of additional security group rules to add to the node security group created. Set `source_cluster_security_group = true` inside rules to set the `cluster_security_group` as source"
  type        = any
  default     = {}
}

variable "subnet_tags" {
  description = "The tags to use for subnet selection"
  type        = map(string)
  default = {
    Tier = "Private"
  }
}

variable "vpc_tags" {
  description = "The tags to use for VPC selection"
  type        = map(string)
  default = {
    Name = "wayfinder"
  }
}

variable "wayfinder_domain_name_api" {
  description = "The domain name to use for the Wayfinder API (e.g. api.wayfinder.example.com)"
  type        = string
}

variable "wayfinder_domain_name_ui" {
  description = "The domain name to use for the Wayfinder UI (e.g. portal.wayfinder.example.com)"
  type        = string
}

variable "wayfinder_release_channel" {
  description = "The release channel to use for Wayfinder"
  type        = string
  default     = "wayfinder-releases"
}

variable "wayfinder_version" {
  description = "The version to use for Wayfinder"
  type        = string
  default     = "v2.0.2"
}
