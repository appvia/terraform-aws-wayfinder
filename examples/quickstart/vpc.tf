module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  azs                          = var.availability_zones
  cidr                         = var.vpc_cidr
  create_database_subnet_group = false
  enable_dns_hostnames         = true
  enable_nat_gateway           = true
  enable_vpn_gateway           = true
  name                         = "wayfinder-${var.environment}"
  one_nat_gateway_per_az       = false
  private_subnets              = var.vpc_private_subnets
  public_subnets               = var.vpc_public_subnets
  single_nat_gateway           = true
  tags                         = var.tags

  public_subnet_tags = merge({
    "kubernetes.io/role/elb" = 1
  }, var.tags)

  private_subnet_tags = merge({
    "kubernetes.io/role/internal-elb" = 1
  }, var.tags)
}
