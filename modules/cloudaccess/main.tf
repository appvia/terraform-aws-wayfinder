locals {
  resource_suffix = var.resource_suffix

  # an AWS IAM OIDC "provider" is NOT required when the trust is to google, nor when the user
  # tells us they're managing it themselves, only when provisioning for an Azure client + tenant ID
  create_azure_trust  = var.wayfinder_identity_azure_client_id != "" && var.wayfinder_identity_azure_tenant_id != "" ? true : false
  create_google_trust = var.wayfinder_identity_gcp_service_account != "" ? true : false

  azure_oidc_issuer = local.create_azure_trust ? "https://sts.windows.net/${var.wayfinder_identity_azure_tenant_id}/" : ""
}
