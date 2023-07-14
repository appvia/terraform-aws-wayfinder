module "externaldns_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.17.0"

  attach_external_dns_policy    = true
  cert_manager_hosted_zone_arns = [data.aws_route53_zone.selected.arn]
  role_name                     = "${local.name}-external-dns"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["external-dns:external-dns"]
    }
  }
}

resource "helm_release" "external-dns" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
  ]

  namespace        = "external-dns"
  create_namespace = true

  name        = "external-dns"
  repository  = "https://charts.bitnami.com/bitnami"
  chart       = "external-dns"
  version     = "6.18.0"
  max_history = 5

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.externaldns_irsa_role.iam_role_arn
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "aws.region"
    value = data.aws_region.current.name
  }
}
