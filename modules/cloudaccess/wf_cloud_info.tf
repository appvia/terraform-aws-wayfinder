module "iam_role_cloud_info" {
  count = var.enable_cloud_info && (var.wayfinder_identity_aws_role_arn != "") ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.17.0"

  create_role             = true
  role_name               = "wf-CloudInfo${local.resource_suffix}"
  role_description        = "Retrieve pricing and instance type metadata"
  role_requires_mfa       = false
  custom_role_policy_arns = [module.iam_policy_cloud_info[0].arn]
  trusted_role_arns       = [var.wayfinder_identity_aws_role_arn]
}

module "iam_role_cloud_info_azure_oidc" {
  count = var.enable_cloud_info && local.create_azure_trust ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.17.0"

  create_role                    = true
  role_name                      = "wf-CloudInfo-azure${local.resource_suffix}"
  role_description               = "Retrieve pricing and instance type metadata"
  role_policy_arns               = [module.iam_policy_cloud_info[0].arn]
  provider_url                   = local.azure_oidc_issuer
  oidc_fully_qualified_audiences = [var.wayfinder_identity_azure_client_id]
}

module "iam_role_cloud_info_google_oidc" {
  count = var.enable_cloud_info && local.create_google_trust ? 1 : 0

  source = "./iam-google-oidc-role"

  create                        = true
  name                          = "wf-CloudInfo-gcp${local.resource_suffix}"
  description                   = "Retrieve pricing and instance type metadata"
  role_policy_arns              = [module.iam_policy_cloud_info[0].arn]
  provider_url                  = "accounts.google.com"
  google_service_account_ids    = [var.wayfinder_identity_gcp_service_account_id]
  google_service_account_emails = [var.wayfinder_identity_gcp_service_account]
}

// Use a file data source so it can be used in the calucation of the graph
data "local_file" "wf_cloud_info_policy" {
  filename = "${path.module}/wf_cloud_info_policy.json"
}

module "iam_policy_cloud_info" {
  count = var.enable_cloud_info ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.17.0"

  name        = "wf-CloudInfo${local.resource_suffix}"
  description = "Retrieve pricing and instance type metadata"

  policy = data.local_file.wf_cloud_info_policy.content
}
