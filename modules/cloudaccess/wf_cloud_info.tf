module "iam_role_cloud_info" {
  count = var.enable_cloud_info && var.from_aws ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.17.0"

  create_role       = true
  role_name         = "wf-CloudInfo${local.resource_suffix}"
  role_description  = "Retrieve pricing and instance type metadata"
  role_requires_mfa = false
  trusted_role_arns = [var.wayfinder_identity_aws_role_arn]
  tags              = var.tags
}

resource "aws_iam_role_policy_attachment" "cloud_info_from_aws" {
  count = var.enable_cloud_info && var.from_aws ? 1 : 0

  role       = module.iam_role_cloud_info[0].iam_role_arn
  policy_arn = module.iam_policy_cloud_info[0].arn

  depends_on = [module.iam_role_cloud_info[0].iam_role_arn, module.iam_policy_cloud_info[0].arn]
}

module "iam_role_cloud_info_azure_oidc" {
  count = var.enable_cloud_info && var.from_azure ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.17.0"

  create_role                    = true
  role_name                      = "wf-CloudInfo-azure${local.resource_suffix}"
  role_description               = "Retrieve pricing and instance type metadata"
  provider_url                   = local.azure_oidc_issuer
  oidc_fully_qualified_audiences = [var.wayfinder_identity_azure_client_id]
  tags                           = var.tags
}

resource "aws_iam_role_policy_attachment" "cloud_info_from_azure" {
  count = var.enable_cloud_info && var.from_azure ? 1 : 0

  role       = module.iam_role_cloud_info_azure_oidc[0].iam_role_arn
  policy_arn = module.iam_policy_cloud_info[0].arn

  depends_on = [module.iam_role_cloud_info_azure_oidc[0].iam_role_arn, module.iam_policy_cloud_info[0].arn]
}

module "iam_role_cloud_info_google_oidc" {
  count = var.enable_cloud_info && var.from_gcp ? 1 : 0

  source = "../iam-google-oidc-role"

  create                        = true
  name                          = "wf-CloudInfo-gcp${local.resource_suffix}"
  description                   = "Retrieve pricing and instance type metadata"
  google_service_account_ids    = [var.wayfinder_identity_gcp_service_account_id]
  google_service_account_emails = [var.wayfinder_identity_gcp_service_account]
  tags                          = var.tags
}

resource "aws_iam_role_policy_attachment" "cloud_info_from_gcp" {
  count = var.enable_cloud_info && var.from_gcp ? 1 : 0

  role       = module.iam_role_cloud_info_google_oidc[0].arn
  policy_arn = module.iam_policy_cloud_info[0].arn

  depends_on = [module.iam_role_cloud_info_google_oidc[0].arn, module.iam_policy_cloud_info[0].arn]
}

// Use a file data source so it can be used in the calculation of the graph
data "local_file" "wf_cloud_info_policy" {
  filename = "${path.module}/wf_cloud_info_policy.json"
}

module "iam_policy_cloud_info" {
  count = var.enable_cloud_info ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.17.0"

  name        = "wf-CloudInfo${local.resource_suffix}"
  description = "Retrieve pricing and instance type metadata"
  policy      = data.local_file.wf_cloud_info_policy.content
  tags        = var.tags
}
