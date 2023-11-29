module "iam_role_network_manager" {
  count = var.enable_network_manager && var.from_aws ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.17.0"

  create_role       = true
  role_name         = "wf-NetworkManager${local.resource_suffix}"
  role_description  = "Create and manage VPCs for EKS clusters"
  role_requires_mfa = false
  trusted_role_arns = [var.wayfinder_identity_aws_role_arn]
  tags              = var.tags
}


resource "aws_iam_role_policy_attachment" "network_manager_from_aws" {
  count = var.enable_network_manager && var.from_aws ? 1 : 0

  role       = module.iam_role_network_manager[0].iam_role_arn
  policy_arn = module.iam_policy_network_manager[0].arn

  depends_on = [module.iam_role_network_manager[0].iam_role_arn, module.iam_policy_network_manager[0].arn]
}

module "iam_role_network_manager_azure_oidc" {
  count = var.enable_network_manager && var.from_azure ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.17.0"

  create_role                    = true
  role_name                      = "wf-NetworkManager-azure${local.resource_suffix}"
  role_description               = "Create and manage VPCs for EKS clusters"
  provider_url                   = local.azure_oidc_issuer
  oidc_fully_qualified_audiences = [var.wayfinder_identity_azure_client_id]
  tags                           = var.tags
}

resource "aws_iam_role_policy_attachment" "network_manager_from_azure" {
  count = var.enable_network_manager && var.from_azure ? 1 : 0

  role       = module.iam_role_network_manager_azure_oidc[0].iam_role_arn
  policy_arn = module.iam_policy_network_manager[0].arn

  depends_on = [module.iam_role_network_manager_azure_oidc[0].iam_role_arn, module.iam_policy_network_manager[0].arn]
}

module "iam_role_network_manager_google_oidc" {
  count = var.enable_network_manager && var.from_gcp ? 1 : 0

  source = "../iam-google-oidc-role"

  create                        = true
  name                          = "wf-NetworkManager-gcp${local.resource_suffix}"
  description                   = "Create and manage VPCs for EKS clusters"
  google_service_account_ids    = [var.wayfinder_identity_gcp_service_account_id]
  google_service_account_emails = [var.wayfinder_identity_gcp_service_account]
  tags                          = var.tags
}

resource "aws_iam_role_policy_attachment" "network_manager_from_gcp" {
  count = var.enable_network_manager && var.from_gcp ? 1 : 0

  role       = module.iam_role_network_manager_google_oidc[0].arn
  policy_arn = module.iam_policy_network_manager[0].arn

  depends_on = [module.iam_role_network_manager_google_oidc[0].arn, module.iam_policy_network_manager[0].arn]
}

// Use a file data source so it can be used in the calculation of the graph
data "local_file" "wf_network_manager_policy" {
  filename = "${path.module}/wf_network_manager_policy.json"
}

module "iam_policy_network_manager" {
  count = var.enable_network_manager ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.17.0"

  name        = "wf-NetworkManager${local.resource_suffix}"
  description = "Create and manage VPCs for EKS clusters"
  policy      = data.local_file.wf_network_manager_policy.content
  tags        = var.tags
}
