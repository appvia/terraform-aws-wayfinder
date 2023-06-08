data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name = format("wayfinder-%s", var.environment)

  tags = {
    Terraform       = "true"
    TerraformModule = "https://github.com/appvia/tf-wayfinder-aws"
    Environment     = var.environment
  }
}
