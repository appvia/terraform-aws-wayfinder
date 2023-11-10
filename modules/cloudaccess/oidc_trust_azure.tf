data "http" "openid-configuration" {
  count = var.from_azure && var.provision_oidc_trust ? 1 : 0

  url = "${local.azure_oidc_issuer}.well-known/openid-configuration"

  lifecycle {
    precondition {
      condition     = var.wayfinder_identity_azure_tenant_id != "" || var.wayfinder_identity_azure_client_id != ""
      error_message = "Must specify wayfinder_identity_azure_tenant_id and wayfinder_identity_azure_client_id to enable cross-cloud trust from Azure to AWS"
    }
  }
}

data "tls_certificate" "jwks" {
  count = var.from_azure && var.provision_oidc_trust ? 1 : 0

  url = jsondecode(data.http.openid-configuration[0].response_body).jwks_uri
}

resource "aws_iam_openid_connect_provider" "wf-trust" {
  count = var.from_azure && var.provision_oidc_trust ? 1 : 0

  client_id_list = [var.wayfinder_identity_azure_client_id]
  url            = local.azure_oidc_issuer
  tags           = var.tags

  thumbprint_list = [
    # This should give us the certificate of the top intermediate CA in the certificate authority chain
    one(
      [
        for cert in data.tls_certificate.jwks[0].certificates :
        cert
        if cert.is_ca
      ]
    ).sha1_fingerprint,
  ]

  lifecycle {
    precondition {
      condition     = var.wayfinder_identity_azure_tenant_id != "" || var.wayfinder_identity_azure_client_id != ""
      error_message = "Must specify wayfinder_identity_azure_tenant_id and wayfinder_identity_azure_client_id to enable cross-cloud trust from Azure to AWS"
    }
  }
}
