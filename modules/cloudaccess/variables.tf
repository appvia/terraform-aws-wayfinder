variable "resource_suffix" {
  default     = ""
  description = "Suffix to apply to all generated resources. We recommend using workspace key + stage."
  type        = string
}

variable "from_aws" {
  default     = true
  description = "Whether Wayfinder is running on AWS."
  type        = bool
}

variable "from_azure" {
  default     = false
  description = "Whether Wayfinder is running on Azure."
  type        = bool
}

variable "from_gcp" {
  default     = false
  description = "Whether Wayfinder is running on GCP."
  type        = bool
}

variable "wayfinder_identity_aws_role_arn" {
  default     = ""
  description = "ARN of Wayfinder's identity to give access to. Populate when Wayfinder is running on AWS with IRSA, or with the user ARN when using a credential-based AWS identity."
  type        = string
}

variable "wayfinder_identity_gcp_service_account" {
  default     = ""
  description = "Email address of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity."
  type        = string
}

variable "wayfinder_identity_gcp_service_account_id" {
  default     = ""
  description = "Numerical ID  of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity."
  type        = string
}

variable "wayfinder_identity_azure_client_id" {
  default     = ""
  description = "Client ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity."
  type        = string
}

variable "wayfinder_identity_azure_tenant_id" {
  default     = ""
  description = "Tenant ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity."
  type        = string
}

variable "provision_oidc_trust" {
  default     = true
  description = "Provisions an AWS OIDC Provider reference for Azure tenant ID. Set to false if you are managing OIDC provider trusts elsewhere."
  type        = bool
}

variable "enable_cluster_manager" {
  default     = false
  description = "Whether to create the Cluster Manager IAM Role"
  type        = bool
}

variable "enable_dns_zone_manager" {
  default     = false
  description = "Whether to create the DNS Zone Manager IAM Role"
  type        = bool
}

variable "enable_network_manager" {
  default     = false
  description = "Whether to create the Network Manager IAM Role"
  type        = bool
}

variable "enable_peering_acceptor" {
  default     = false
  description = "Whether to create the Peering Acceptor IAM Role"
  type        = bool
}

variable "enable_cloud_info" {
  default     = false
  description = "Whether to create the Cloud Info IAM Role"
  type        = bool
}

variable "tags" {
  default     = {}
  description = "A map of tags to add to all resources created."
  type        = map(string)
}
