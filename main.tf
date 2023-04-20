data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "selected" {
  tags = var.vpc_tags
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = var.subnet_tags
}

locals {
  name = format("wayfinder-%s", var.environment)

  tags = {
    Terraform       = "true"
    TerraformModule = "https://github.com/appvia/tf-wayfinder-aws"
    Environment     = var.environment
  }
}
