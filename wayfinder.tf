locals {
  wayfinder_instance_id = substr(md5(format("aws-%s-%s-%s", data.aws_caller_identity.current.account_id, data.aws_region.current.name, var.environment)), 0, 12)
}

data "aws_secretsmanager_secret" "wayfinder" {
  name = var.aws_secretsmanager_name
}

data "aws_secretsmanager_secret_version" "wayfinder" {
  secret_id = data.aws_secretsmanager_secret.wayfinder.id
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
}

module "wayfinder_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.17.0"

  cert_manager_hosted_zone_arns = [data.aws_route53_zone.selected.arn]
  role_name                     = "${local.name}-irsa"
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

data "template_file" "wayfinder_values" {
  template = file("${path.module}/manifests/wayfinder-values.yml.tpl")
  vars = {
    api_hostname                  = var.wayfinder_domain_name_api
    ui_hostname                   = var.wayfinder_domain_name_ui
    wayfinder_instance_identifier = local.wayfinder_instance_id
    wayfinder_iam_identity        = module.wayfinder_irsa_role.iam_role_arn
  }
}

resource "helm_release" "wayfinder" {
  depends_on = [
    helm_release.certmanager,
    helm_release.external-dns,
    helm_release.ingress,
    kubectl_manifest.certmanager_clusterissuer,
    module.eks,
    module.wayfinder_irsa_role,
  ]

  name = "wayfinder"

  chart            = "https://storage.googleapis.com/${var.wayfinder_release_channel}/${var.wayfinder_version}/wayfinder-helm-chart.tgz"
  create_namespace = true
  max_history      = 5
  namespace        = "wayfinder"

  values = [
    "${data.template_file.wayfinder_values.rendered}"
  ]

  set_sensitive {
    name  = "licenseKey"
    value = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["licenseKey"]
  }

  set_sensitive {
    name  = "idp.clientId"
    value = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["idpClientId"]
  }

  set_sensitive {
    name  = "idp.clientSecret"
    value = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["idpClientSecret"]
  }

  set_sensitive {
    name  = "idp.serverUrl"
    value = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["idpServerUrl"]
  }
}
