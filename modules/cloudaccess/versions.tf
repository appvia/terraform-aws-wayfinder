terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.62"
    }

    http = {
      source  = "hashicorp/http"
      version = ">= 3.4"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.4"
    }
  }
}
