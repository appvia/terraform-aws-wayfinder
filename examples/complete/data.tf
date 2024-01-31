data "aws_caller_identity" "current" {}

data "aws_route53_zone" "selected" {
  name = var.dns_zone_name
}

data "aws_secretsmanager_secret" "wayfinder" {
  name = var.aws_secretsmanager_name
}

data "aws_secretsmanager_secret_version" "wayfinder" {
  secret_id = data.aws_secretsmanager_secret.wayfinder.id
}

data "aws_subnets" "private_subnets_by_az" {
  for_each = toset(var.availability_zones)
  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }
  filter {
    name   = "availability-zone"
    values = [each.key]
  }
  tags = {
    Tier = "Private"
  }

  depends_on = [module.vpc]
}

locals {
  private_subnets_by_az = {
    for az, subnet in data.aws_subnets.private_subnets_by_az : az => subnet.ids
  }
}
