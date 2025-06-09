module "wayfinder_cloudaccess" {
  source = "github.com/appvia/terraform-aws-wayfinder//modules/cloudaccess?ref=v3"

  resource_suffix = var.resource_suffix
  role_name      = var.role_name
  tags           = var.tags

  enable_cluster_manager_permissions  = var.enable_cluster_manager_permissions
  enable_dns_zone_manager_permissions = var.enable_dns_zone_manager_permissions
  enable_network_manager_permissions  = var.enable_network_manager_permissions
  enable_cloud_info_permissions      = var.enable_cloud_info_permissions
  enable_peering_acceptor_permissions = var.enable_peering_acceptor_permissions

  from_aws   = var.from_aws
  from_azure = var.from_azure
  from_gcp   = var.from_gcp

  provision_oidc_trust                      = var.provision_oidc_trust
  wayfinder_identity_azure_client_id        = var.wayfinder_identity_azure_client_id
  wayfinder_identity_azure_tenant_id        = var.wayfinder_identity_azure_tenant_id
  wayfinder_identity_aws_role_arn           = var.wayfinder_identity_aws_role_arn
  wayfinder_identity_gcp_service_account    = var.wayfinder_identity_gcp_service_account
  wayfinder_identity_gcp_service_account_id = var.wayfinder_identity_gcp_service_account_id

  custom_policy_arns      = var.custom_policy_arns
  custom_policy_documents = [for file in var.custom_policy_documents : file(file)]
}
