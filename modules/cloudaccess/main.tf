locals {
  resource_suffix   = var.resource_suffix != "" ? "-${var.resource_suffix}" : ""
  azure_oidc_issuer = var.wayfinder_identity_azure_tenant_id != "" ? "https://sts.windows.net/${var.wayfinder_identity_azure_tenant_id}/" : ""
}
