variable "resource_suffix" {
  default     = ""
  description = "Suffix to apply to all generated resources. We recommend using workspace key + stage."
  type        = string
}

variable "role_name" {
  default     = "wayfinder"
  description = "Name to use for the generated role, will have resource_suffix appended"
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

variable "enable_cluster_manager_permissions" {
  default     = false
  description = "Whether to grant Cluster Manager permissions to the generated IAM Role"
  type        = bool
}

variable "enable_dns_zone_manager_permissions" {
  default     = false
  description = "Whether to grant DNS Zone Manager permissions to the generated IAM Role"
  type        = bool
}

variable "enable_network_manager_permissions" {
  default     = false
  description = "Whether to grant Network Manager permissions to the generated IAM Role"
  type        = bool
}

variable "enable_peering_acceptor_permissions" {
  default     = false
  description = "Whether to grant Peering Acceptor permissions to the generated IAM Role"
  type        = bool
}

variable "enable_cloud_info_permissions" {
  default     = false
  description = "Whether to grant Cloud Info permissions to the generated IAM Role"
  type        = bool
}

variable "tags" {
  default     = {}
  description = "A map of tags to add to all resources created."
  type        = map(string)
}

variable "custom_policy_arns" {
  default     = []
  description = "List of custom IAM policy ARNs to attach to the role in addition to the built-in policies."
  type        = list(string)
}

variable "custom_policy_documents" {
  default     = []
  description = "List of custom IAM policy documents in JSON format. Each policy will be created as a separate IAM policy resource with an auto-generated name."
  type        = list(string)
}
