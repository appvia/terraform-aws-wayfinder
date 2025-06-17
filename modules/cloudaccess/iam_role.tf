module "iam_role" {
  count = var.from_aws ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.45.0"

  create_role             = true
  role_name               = "${var.role_name}${local.resource_suffix}"
  role_description        = "A role for use by wayfinder"
  role_requires_mfa       = false
  custom_role_policy_arns = local.enabled_policies
  trusted_role_arns       = [var.wayfinder_identity_aws_role_arn]
  tags                    = var.tags
}

module "iam_role_azure_oidc" {
  count = var.from_azure ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.45.0"

  create_role                    = true
  role_name                      = "${var.role_name}${local.resource_suffix}"
  role_description               = "A role for use by wayfinder"
  role_policy_arns               = local.enabled_policies
  provider_url                   = local.azure_oidc_issuer
  oidc_fully_qualified_audiences = [var.wayfinder_identity_azure_client_id]
  tags                           = var.tags
}

module "iam_role_google_oidc" {
  count = var.from_gcp ? 1 : 0

  source = "../iam-google-oidc-role"

  create                        = true
  name                          = "${var.role_name}${local.resource_suffix}"
  description                   = "A role for use by wayfinder"
  role_policy_arns              = local.enabled_policies
  google_service_account_ids    = [var.wayfinder_identity_gcp_service_account_id]
  google_service_account_emails = [var.wayfinder_identity_gcp_service_account]
  tags                          = var.tags
}