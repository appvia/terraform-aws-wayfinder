locals {
  wayfinder_instance_id = var.wayfinder_instance_id != "" ? var.wayfinder_instance_id : substr(md5(format("aws-%s-%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name, var.environment)), 0, 12)
}

data "aws_secretsmanager_secret" "wayfinder" {
  name = var.aws_secretsmanager_name
}

data "aws_secretsmanager_secret_version" "wayfinder" {
  secret_id = data.aws_secretsmanager_secret.wayfinder.id
}

resource "kubectl_manifest" "storageclass" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
  ]

  yaml_body = templatefile("${path.module}/manifests/storageclass.yml.tpl", {
    name = "gp2"
  })
}

resource "kubectl_manifest" "storageclass_encrypted" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
  ]

  yaml_body = templatefile("${path.module}/manifests/storageclass-encrypted.yml.tpl", {
    name = "gp2-encrypted"
  })
}

resource "kubectl_manifest" "wayfinder_namespace" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-namespace.yml.tpl", {
    namespace = "wayfinder"
  })
}

resource "kubectl_manifest" "wayfinder_idp" {
  count = (var.enable_k8s_resources && var.idp_provider == "generic") ? 1 : 0

  depends_on = [
    kubectl_manifest.wayfinder_namespace,
    module.eks,
  ]

  sensitive_fields = ["stringData"]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-idp.yml.tpl", {
    claims        = "preferred_username,email,name,username"
    client_id     = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["idpClientId"]
    client_scopes = "email,profile,offline_access"
    client_secret = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["idpClientSecret"]
    name          = "wayfinder-idp-live"
    namespace     = "wayfinder"
    server_url    = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["idpServerUrl"]
  })
}

resource "kubectl_manifest" "wayfinder_idp_aad" {
  count = (var.enable_k8s_resources && var.idp_provider == "aad") ? 1 : 0

  depends_on = [
    kubectl_manifest.wayfinder_namespace,
    module.eks,
  ]

  sensitive_fields = ["stringData"]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-idp-aad.yml.tpl", {
    claims        = "preferred_username,email,name,username"
    client_id     = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["idpClientId"]
    client_scopes = "email,profile,offline_access"
    client_secret = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["idpClientSecret"]
    name          = "wayfinder-idp-live"
    namespace     = "wayfinder"
    provider      = "azure"
    tenant_id     = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["idpAzureTenantId"]
  })
}

data "aws_iam_policy_document" "wayfinder_irsa_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      "arn:aws:iam::*:role/wf-*",
    ]
  }

  statement {
    actions = [
      "aws-marketplace:MeterUsage",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "wayfinder_irsa_policy" {
  name   = "${local.name}-irsa"
  path   = "/"
  policy = data.aws_iam_policy_document.wayfinder_irsa_policy.json
  tags   = local.tags
}

module "wayfinder_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.17.0"

  cert_manager_hosted_zone_arns = [data.aws_route53_zone.selected.arn]
  role_name                     = "${local.name}-irsa"
  tags                          = local.tags

  role_policy_arns = {
    policy = aws_iam_policy.wayfinder_irsa_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["wayfinder:wayfinder-admin"]
    }
  }
}

resource "helm_release" "wayfinder" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.certmanager,
    helm_release.external-dns,
    helm_release.ingress,
    kubectl_manifest.certmanager_clusterissuer,
    kubectl_manifest.storageclass_encrypted,
    module.eks,
    module.wayfinder_irsa_role,
    kubectl_manifest.wayfinder_idp,
    kubectl_manifest.wayfinder_idp_aad,
  ]

  name = "wayfinder"

  chart            = "https://storage.googleapis.com/${var.wayfinder_release_channel}/${var.wayfinder_version}/wayfinder-helm-chart.tgz"
  create_namespace = false
  max_history      = 5
  namespace        = "wayfinder"

  values = [
    "${templatefile("${path.module}/manifests/wayfinder-values.yml.tpl", {
      api_hostname                  = var.wayfinder_domain_name_api
      storage_class                 = "gp2-encrypted"
      ui_hostname                   = var.wayfinder_domain_name_ui
      wayfinder_iam_identity        = module.wayfinder_irsa_role.iam_role_arn
      wayfinder_instance_identifier = local.wayfinder_instance_id
    })}"
  ]

  set_sensitive {
    name  = "licenseKey"
    value = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["licenseKey"]
  }
}
