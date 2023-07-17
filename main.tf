data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name = format("wayfinder-%s", var.environment)

  tags = merge({
    Provisioner = "Terraform"
    Environment = var.environment
  }, var.tags)
}
