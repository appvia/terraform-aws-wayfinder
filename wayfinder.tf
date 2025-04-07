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
    name = "${var.eks_encrypted_sc_type}-encrypted"
    type = var.eks_encrypted_sc_type
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
  count = (var.enable_k8s_resources && var.wayfinder_idp_details["type"] == "generic") ? 1 : 0

  depends_on = [
    kubectl_manifest.wayfinder_namespace,
    module.eks,
  ]

  sensitive_fields = ["stringData"]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-idp.yml.tpl", {
    claims        = "preferred_username,email,name,username"
    client_id     = var.wayfinder_idp_details["clientId"]
    client_scopes = "email,profile,offline_access"
    client_secret = var.wayfinder_idp_details["clientSecret"]
    name          = "wayfinder-idp-live"
    namespace     = "wayfinder"
    server_url    = var.wayfinder_idp_details["serverUrl"]
  })
}

resource "kubectl_manifest" "wayfinder_idp_aad" {
  count = (var.enable_k8s_resources && var.wayfinder_idp_details["type"] == "aad") ? 1 : 0

  depends_on = [
    kubectl_manifest.wayfinder_namespace,
    module.eks,
  ]

  sensitive_fields = ["stringData"]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-idp-aad.yml.tpl", {
    claims        = "preferred_username,email,name,username"
    client_id     = var.wayfinder_idp_details["clientId"]
    client_scopes = "email,profile,offline_access"
    client_secret = var.wayfinder_idp_details["clientSecret"]
    name          = "wayfinder-idp-live"
    namespace     = "wayfinder"
    provider      = "azure"
    tenant_id     = var.wayfinder_idp_details["azureTenantId"]
  })
}

# tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "wayfinder_irsa_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    #tfsec:ignore:aws-iam-no-policy-wildcards
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
  version = "5.54.1"

  role_name = "${local.name}-irsa"
  tags      = local.tags

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

resource "random_password" "wayfinder_localadmin" {
  count   = var.create_localadmin_user ? 1 : 0
  length  = 20
  special = false
}

resource "helm_release" "wayfinder" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.certmanager,
    helm_release.external_dns,
    helm_release.ingress,
    helm_release.load_balancer_controller,
    kubectl_manifest.certmanager_clusterissuer,
    kubectl_manifest.storageclass_encrypted,
    kubectl_manifest.wayfinder_idp_aad,
    kubectl_manifest.wayfinder_idp,
    kubectl_manifest.wayfinder_namespace,
    module.eks,
    module.wayfinder_irsa_role,
  ]

  name = "wayfinder"

  chart            = "https://storage.googleapis.com/${var.wayfinder_release_channel}/${var.wayfinder_version}/wayfinder-helm-chart.tgz"
  create_namespace = false
  max_history      = 5
  namespace        = "wayfinder"
  wait             = true
  wait_for_jobs    = true

  values = [
    templatefile("${path.module}/manifests/wayfinder-values.yml.tpl", {
      api_hostname                  = var.wayfinder_domain_name_api
      custom_logo_url               = var.wayfinder_custom_logo_url
      custom_logo_collapsed_url     = var.wayfinder_custom_logo_collapsed_url
      disable_local_login           = var.wayfinder_idp_details["type"] == "none" ? false : var.disable_local_login
      enable_localadmin_user        = var.create_localadmin_user
      no_defaults                   = var.wayfinder_no_defaults
      storage_class                 = "${var.eks_encrypted_sc_type}-encrypted"
      ui_hostname                   = var.wayfinder_domain_name_ui
      wayfinder_iam_identity        = module.wayfinder_irsa_role.iam_role_arn
      wayfinder_instance_identifier = var.wayfinder_instance_id
    })
  ]

  set_sensitive {
    name  = "licenseKey"
    value = var.wayfinder_licence_key
  }

  set_sensitive {
    name  = "localAdminPassword"
    value = var.create_localadmin_user ? random_password.wayfinder_localadmin[0].result : ""
  }
}
