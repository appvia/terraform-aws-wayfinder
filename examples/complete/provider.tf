provider "aws" {}

provider "kubernetes" {}

provider "helm" {
  kubernetes {
    host                   = module.wayfinder.cluster_endpoint
    cluster_ca_certificate = base64decode(module.wayfinder.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.wayfinder.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  host                   = module.wayfinder.cluster_endpoint
  cluster_ca_certificate = base64decode(module.wayfinder.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.wayfinder.cluster_name]
    command     = "aws"
  }
}
