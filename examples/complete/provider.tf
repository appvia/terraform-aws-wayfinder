provider "aws" {}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(module.wayfinder.cluster_certificate_authority_data)
    host                   = module.wayfinder.cluster_endpoint

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.wayfinder.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubectl" {
  cluster_ca_certificate = base64decode(module.wayfinder.cluster_certificate_authority_data)
  host                   = module.wayfinder.cluster_endpoint
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.wayfinder.cluster_name]
    command     = "aws"
  }
}
