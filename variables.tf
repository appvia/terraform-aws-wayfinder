variable "clusterissuer_email" {
  description = "The email address to use for the cert-manager cluster issuer."
  type        = string
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_security_group_additional_rules" {
  description = "List of additional security group rules to add to the cluster security group created. Set `source_node_security_group = true` inside rules to set the `node_security_group` as source."
  type        = any
  default     = {}
}

variable "cluster_version" {
  description = "The Kubernetes version to use for the EKS cluster."
  type        = string
  default     = "1.26"
}

variable "create_localadmin_user" {
  description = "Whether to create a localadmin user for access to the Wayfinder Portal and API."
  type        = bool
  default     = true
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

variable "dns_zone_arn" {
  description = "The AWS Route53 DNS Zone ARN to use (e.g. arn:aws:route53:::hostedzone/ABCDEFG1234567)."
  type        = string
}

variable "ebs_csi_kms_cmk_ids" {
  description = "List of KMS CMKs to allow EBS CSI to manage encrypted volumes. This is required if EBS encryption is set at the account level with a default KMS CMK."
  type        = list(string)
  default     = []
}

variable "eks_aws_auth_roles" {
  description = "List of IAM Role maps to add to the aws-auth configmap. This is required if you use a different IAM Role for Terraform Plan actions."
  default     = []
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "eks_ng_capacity_type" {
  description = "The capacity type to use for the EKS managed node group."
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_ng_desired_size" {
  description = "The desired size to use for the EKS managed node group."
  type        = number
  default     = 2
}

variable "eks_ng_instance_types" {
  description = "The instance types to use for the EKS managed node group."
  type        = list(string)
  default     = ["t3.xlarge"]
}

variable "eks_ng_minimum_size" {
  description = "The minimum size to use for the EKS managed node group."
  type        = number
  default     = 2
}

variable "enable_k8s_resources" {
  description = "Whether to enable the creation of Kubernetes resources for Wayfinder (helm and kubectl manifest deployments)."
  type        = bool
  default     = true
}

variable "enable_wf_cloudaccess" {
  description = "Whether to configure CloudIdentity resource in Wayfinder for the configured AWS IRSA identity once installed (requires enable_k8s_resources)"
  type        = bool
  default     = true
}

variable "enable_wf_costestimates" {
  description = "Whether to configure admin CloudAccessConfig for cost estimates in the account Wayfinder is installed in once installed (requires enable_k8s_resources and enable_wf_cloudaccess)"
  type        = bool
  default     = true
}

variable "enable_wf_dnszonemanager" {
  description = "Whether to configure admin CloudAccessConfig for DNS zone management in the account Wayfinder is installed in once installed (requires enable_k8s_resources and enable_wf_cloudaccess)"
  type        = bool
  default     = false
}

variable "environment" {
  description = "The environment name we are provisioning."
  type        = string
  default     = "production"
}

variable "kms_key_administrators" {
  description = "A list of IAM ARNs for EKS key administrators. If no value is provided, the current caller identity is used to ensure at least one key admin is available."
  type        = list(string)
  default     = []
}

variable "node_security_group_additional_rules" {
  description = "List of additional security group rules to add to the node security group created. Set `source_cluster_security_group = true` inside rules to set the `cluster_security_group` as source."
  type        = any
  default     = {}
}

variable "subnet_ids" {
  description = "A list of private Subnet IDs to launch the Wayfinder EKS Nodes onto."
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources created."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The VPC ID for the Wayfinder EKS Cluster to be built within."
  type        = string
}

variable "wayfinder_domain_name_api" {
  description = "The domain name to use for the Wayfinder API (e.g. api.wayfinder.example.com)."
  type        = string
}

variable "wayfinder_domain_name_ui" {
  description = "The domain name to use for the Wayfinder UI (e.g. portal.wayfinder.example.com)."
  type        = string
}

variable "wayfinder_idp_details" {
  description = "The IDP details to use for Wayfinder to enable SSO."
  type = object({
    type          = string
    clientId      = optional(string)
    clientSecret  = optional(string)
    serverUrl     = optional(string)
    azureTenantId = optional(string)
  })

  sensitive = true

  validation {
    condition     = contains(["generic", "aad", "none"], var.wayfinder_idp_details["type"])
    error_message = "wayfinder_idp_details[\"type\"] must be one of: generic, aad, none"
  }

  validation {
    condition     = var.wayfinder_idp_details["type"] == "none" || (var.wayfinder_idp_details["type"] == "generic" && length(var.wayfinder_idp_details["serverUrl"]) > 0) || (var.wayfinder_idp_details["type"] == "aad" && length(var.wayfinder_idp_details["azureTenantId"]) > 0)
    error_message = "serverUrl must be set if IDP type is generic, azureTenantId must be set if IDP type is aad"
  }

  default = {
    type          = "none"
    clientId      = null
    clientSecret  = null
    serverUrl     = ""
    azureTenantId = ""
  }
}

variable "wayfinder_instance_id" {
  description = "The instance ID to use for Wayfinder."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{10,20}$", var.wayfinder_instance_id))
    error_message = "The Wayfinder Instance ID must be alphanumeric and 10-20 characters long."
  }
}

variable "wayfinder_licence_key" {
  description = "The licence key to use for Wayfinder."
  type        = string
  sensitive   = true
}

variable "wayfinder_release_channel" {
  description = "The release channel to use for Wayfinder."
  type        = string
  default     = "wayfinder-releases"
}

variable "wayfinder_version" {
  description = "The version to use for Wayfinder."
  type        = string
  default     = "v2.4.6"
}

variable "aws_ebs_csi_driver_addon_version" {
  description = "The version to use for the AWS EBS CSI driver."
  type        = string
  default     = "v1.20.0-eksbuild.1"
}

variable "coredns_addon_version" {
  description = "CoreDNS Addon version to use."
  type        = string
  default     = "v1.9.3-eksbuild.9"
}

variable "kube_proxy_addon_version" {
  description = "Kube Proxy Addon version to use."
  type        = string
  default     = "v1.26.9-eksbuild.2"
}

variable "aws_vpc_cni_addon_version" {
  description = "AWS VPC CNI Addon version to use."
  type        = string
  default     = "v1.13.4-eksbuild.1"
}
