#trivy:ignore:AVD-AWS-0057
module "load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.58.0"

  attach_load_balancer_controller_policy = true
  role_name                              = "${local.name}-load-balancer-controller"
  tags                                   = local.tags

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

/*
The LBC deploys a mutating webhook for Service resources.
In order to avoid potential apply errors due to helm charts
being applied in parallel, we make all other helm charts
depend on this first being deployed and fully available.
*/
resource "helm_release" "load_balancer_controller" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
    module.load_balancer_controller_irsa_role
  ]

  namespace        = "kube-system"
  create_namespace = false

  name        = "aws-load-balancer-controller"
  repository  = "https://aws.github.io/eks-charts"
  chart       = "aws-load-balancer-controller"
  version     = "1.8.4"
  max_history = 5

  set {
    name  = "clusterName"
    value = local.name
  }

  set {
    name  = "createIngressClassResource"
    value = "false"
  }

  set {
    name  = "ingressClassParams.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.load_balancer_controller_irsa_role.iam_role_arn
  }
}

resource "helm_release" "ingress" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
    helm_release.load_balancer_controller,
  ]

  namespace        = "ingress-nginx"
  create_namespace = true

  name        = "ingress-nginx"
  repository  = "https://kubernetes.github.io/ingress-nginx"
  chart       = "ingress-nginx"
  version     = "4.11.2"
  max_history = 5

  set {
    name  = "defaultBackend.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = var.disable_internet_access ? "internal" : "internet-facing"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "external"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-nlb-target-type"
    value = "instance"
  }

  set {
    name  = "controller.config.use-proxy-protocol"
    value = "true"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-proxy-protocol"
    value = "*"
  }
}
