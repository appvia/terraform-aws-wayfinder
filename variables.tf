variable "aws_secretsmanager_name" {
  description = "The name of the AWS Secrets Manager secret to use for Wayfinder. Must already exist and contain: 'licenseKey', 'idpClientId', 'idpClientSecret', 'idpServerUrl'"
  type        = string
  default     = "wayfinder-secrets"
}

variable "clusterissuer_email" {
  description = "The email address to use for the cert-manager cluster issuer"
  type        = string
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source"
  type        = any
  default     = {}
}

variable "cluster_version" {
  description = "The Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.25"
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

variable "ebs_csi_kms_cmk_ids" {
  description = "List of KMS CMKs to allow EBS CSI to manage encrypted volumes. This is required if EBS encryption is set at the account level with a default KMS CMK."
  type        = list(string)
  default     = []
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

variable "idp_provider" {
  description = "The Identity Provider type to configure for Wayfinder (supported: generic, aad)"
  type        = string
  default     = "generic"

  validation {
    condition     = contains(["generic", "aad"], var.idp_provider)
    error_message = "idp_provider must be one of: generic, aad"
  }
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

variable "subnet_ids" {
  description = "A list of private Subnet IDs to launch the Wayfinder EKS Nodes onto"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID for the Wayfinder EKS Cluster to be built within"
  type        = string
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
  default     = "v2.1.1"
}

variable "aws_ebs_csi_driver_addon_version" {
  description = "The version to use for the AWS EBS CSI driver"
  type        = string
  default     = "v1.19.0-eksbuild.2"
}

variable "coredns_addon_version" {
  description = "CoreDNS Addon version to use"
  type        = string
  default     = "v1.9.3-eksbuild.5"
}

variable "kube_proxy_addon_version" {
  description = "Kube Proxy Addon version to use"
  type        = string
  default     = "v1.25.9-eksbuild.1"
}

variable "aws_vpc_cni_addon_version" {
  description = "AWS VPC CNI Addon version to use"
  type        = string
  default     = "v1.12.6-eksbuild.2"
}
