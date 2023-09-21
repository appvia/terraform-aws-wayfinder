variable "create_cluster_manager_role" {
  default     = true
  description = "Whether to create the Cluster Manager IAM Role"
  type        = bool
}

variable "create_dns_zone_manager_role" {
  default     = true
  description = "Whether to create the DNS Zone Manager IAM Role"
  type        = bool
}

variable "create_network_manager_role" {
  default     = true
  description = "Whether to create the Network Manager IAM Role"
  type        = bool
}

variable "instance_id" {
  default     = ""
  description = "A Wayfinder instance ID if roles are to be kept unique to an instance"
  type        = string
}

variable "wayfinder_iam_role_arn" {
  description = "The ARN of Wayfinder's IAM role to allow in trust policies"
  type        = string
}

variable "workspace_id" {
  default     = ""
  description = "A Wayfinder workspace ID if Roles are to be kept unique to a workspace"
  type        = string
}

variable "permissions_boundary_policy_arn" {
  description = "ARN of the AWS permissions boundary policy to apply to IAM roles"
  type        = string
  default     = ""
}
