module "iam_role_cluster_manager" {
  count = var.enable_cluster_manager && var.from_aws ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.48.0"

  create_role             = true
  role_name               = "wf-ClusterManager${local.resource_suffix}"
  role_description        = "Create and manage EKS Kubernetes clusters"
  role_requires_mfa       = false
  custom_role_policy_arns = [module.iam_policy_cluster_manager[0].arn]
  trusted_role_arns       = [var.wayfinder_identity_aws_role_arn]
  tags                    = var.tags
}

module "iam_role_cluster_manager_azure_oidc" {
  count = var.enable_cluster_manager && var.from_azure ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.48.0"

  create_role                    = true
  role_name                      = "wf-ClusterManager-azure${local.resource_suffix}"
  role_description               = "Create and manage EKS Kubernetes clusters"
  role_policy_arns               = [module.iam_policy_cluster_manager[0].arn]
  provider_url                   = local.azure_oidc_issuer
  oidc_fully_qualified_audiences = [var.wayfinder_identity_azure_client_id]
  tags                           = var.tags
}

module "iam_role_cluster_manager_google_oidc" {
  count = var.enable_cluster_manager && var.from_gcp ? 1 : 0

  source = "../iam-google-oidc-role"

  create                        = true
  name                          = "wf-ClusterManager-gcp${local.resource_suffix}"
  description                   = "Create and manage EKS Kubernetes clusters"
  role_policy_arns              = [module.iam_policy_cluster_manager[0].arn]
  google_service_account_ids    = [var.wayfinder_identity_gcp_service_account_id]
  google_service_account_emails = [var.wayfinder_identity_gcp_service_account]
  tags                          = var.tags
}

// Use a file data source so it can be used in the calculation of the graph
data "local_file" "wf_cluster_manager_policy" {
  filename = "${path.module}/wf_cluster_manager_policy.json"
}

module "iam_policy_cluster_manager" {
  count = var.enable_cluster_manager ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.48.0"

  name        = "wf-ClusterManager${local.resource_suffix}"
  description = "Create and manage EKS Kubernetes clusters"
  policy      = data.local_file.wf_cluster_manager_policy.content
  tags        = var.tags
}
