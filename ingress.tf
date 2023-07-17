resource "helm_release" "ingress" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    module.eks,
  ]

  namespace        = "ingress-nginx"
  create_namespace = true

  name        = "ingress-nginx"
  repository  = "https://kubernetes.github.io/ingress-nginx"
  chart       = "ingress-nginx"
  version     = "4.6.0"
  max_history = 5

  set {
    name  = "defaultBackend.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-internal"
    value = tostring(var.disable_internet_access)
  }
}
