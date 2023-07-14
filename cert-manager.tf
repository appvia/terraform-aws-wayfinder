data "aws_route53_zone" "selected" {
  name         = var.dns_zone_name
  private_zone = false
}

module "certmanager_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.17.0"

  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = [data.aws_route53_zone.selected.arn]
  role_name                     = "${local.name}-cert-manager"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }
}

resource "helm_release" "certmanager" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
  ]

  namespace        = "cert-manager"
  create_namespace = true

  name        = "cert-manager"
  repository  = "https://charts.jetstack.io"
  chart       = "cert-manager"
  version     = "v1.11.0"
  max_history = 5

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.certmanager_irsa_role.iam_role_arn
  }

  set {
    name  = "ingressShim.defaultIssuerName"
    value = "letsencrypt-prod"
  }

  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }

  set {
    name  = "ingressShim.defaultIssuerGroup"
    value = "cert-manager.io"
  }
}

resource "kubectl_manifest" "certmanager_clusterissuer" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
    helm_release.certmanager,
  ]

  yaml_body = templatefile("${path.module}/manifests/certmanager-clusterissuer.yml.tpl", {
    email  = var.clusterissuer_email
    region = data.aws_region.current.name
  })
}
