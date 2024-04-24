module "iam_role_dns_zone_manager" {
  count = var.enable_dns_zone_manager && var.from_aws ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.39.0"

  create_role             = true
  role_name               = "wf-DNSZoneManager${local.resource_suffix}"
  role_description        = "Create and manage Route 53 DNS Zones for automated DNS management"
  role_requires_mfa       = false
  custom_role_policy_arns = [module.iam_policy_dns_zone_manager[0].arn]
  trusted_role_arns       = [var.wayfinder_identity_aws_role_arn]
  tags                    = var.tags
}

module "iam_role_dns_zone_manager_azure_oidc" {
  count = var.enable_dns_zone_manager && var.from_azure ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                    = true
  role_name                      = "wf-DNSZoneManager-azure${local.resource_suffix}"
  role_description               = "Create and manage Route 53 DNS Zones for automated DNS management"
  role_policy_arns               = [module.iam_policy_dns_zone_manager[0].arn]
  provider_url                   = local.azure_oidc_issuer
  oidc_fully_qualified_audiences = [var.wayfinder_identity_azure_client_id]
  tags                           = var.tags
}

module "iam_role_dns_zone_manager_google_oidc" {
  count = var.enable_dns_zone_manager && var.from_gcp ? 1 : 0

  source = "../iam-google-oidc-role"

  create                        = true
  name                          = "wf-DNSZoneManager-gcp${local.resource_suffix}"
  description                   = "Create and manage Route 53 DNS Zones for automated DNS management"
  role_policy_arns              = [module.iam_policy_dns_zone_manager[0].arn]
  google_service_account_ids    = [var.wayfinder_identity_gcp_service_account_id]
  google_service_account_emails = [var.wayfinder_identity_gcp_service_account]
  tags                          = var.tags
}

// Use a file data source so it can be used in the calculation of the graph
data "local_file" "wf_dns_zone_manager_policy" {
  filename = "${path.module}/wf_dns_zone_manager_policy.json"
}

module "iam_policy_dns_zone_manager" {
  count = var.enable_dns_zone_manager ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.39.0"

  name        = "wf-DNSZoneManager${local.resource_suffix}"
  description = "Create and manage Route 53 DNS Zones for automated DNS management"
  policy      = data.local_file.wf_dns_zone_manager_policy.content
  tags        = var.tags
}
