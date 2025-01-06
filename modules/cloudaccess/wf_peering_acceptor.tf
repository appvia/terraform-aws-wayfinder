module "iam_role_peering_acceptor" {
  count = var.enable_peering_acceptor && var.from_aws ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.52.1"

  create_role             = true
  role_name               = "wf-PeeringAcceptor${local.resource_suffix}"
  role_description        = "Accept peering connections in aws"
  role_requires_mfa       = false
  custom_role_policy_arns = [module.iam_policy_peering_acceptor[0].arn]
  trusted_role_arns       = [var.wayfinder_identity_aws_role_arn]
}

module "iam_role_peering_acceptor_azure_oidc" {
  count = var.enable_peering_acceptor && var.from_azure ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.52.1"

  create_role                    = true
  role_name                      = "wf-PeeringAcceptor-azure${local.resource_suffix}"
  role_description               = "Accept peering connections in aws"
  role_policy_arns               = [module.iam_policy_peering_acceptor[0].arn]
  provider_url                   = local.azure_oidc_issuer
  oidc_fully_qualified_audiences = [var.wayfinder_identity_azure_client_id]
}

module "iam_role_peering_acceptor_google_oidc" {
  count = var.enable_peering_acceptor && var.from_gcp ? 1 : 0

  source = "../iam-google-oidc-role"

  create                        = true
  name                          = "wf-PeeringAcceptor-gcp${local.resource_suffix}"
  description                   = "Accept peering connections in aws"
  role_policy_arns              = [module.iam_policy_peering_acceptor[0].arn]
  google_service_account_ids    = [var.wayfinder_identity_gcp_service_account_id]
  google_service_account_emails = [var.wayfinder_identity_gcp_service_account]
}

// Use a file data source so it can be used in the calucation of the graph
data "local_file" "wf_peering_acceptor_policy" {
  filename = "${path.module}/wf_peering_acceptor_policy.json"
}

module "iam_policy_peering_acceptor" {
  count = var.enable_peering_acceptor ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.52.1"

  name        = "wf-PeeringAcceptor${local.resource_suffix}"
  description = "Accept peering connections in aws"

  policy = data.local_file.wf_peering_acceptor_policy.content
}
