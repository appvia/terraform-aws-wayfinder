module "wayfinder" {
  source = "../"

  aws_secretsmanager_name                 = "wayfinder-prod-secrets"
  clusterissuer_email                     = "certmanager-notifications@example.com"
  disable_internet_access                 = true
  dns_zone_name                           = "wayfinder.example.com"
  eks_ng_capacity_type                    = "ON_DEMAND"
  eks_ng_desired_size                     = 2
  eks_ng_instance_types                   = ["t3.xlarge"]
  eks_ng_minimum_size                     = 2
  environment                             = "prod"
  kms_key_administrators                  = ["arn:aws:iam::111222333444:root"]
  wayfinder_domain_name_api               = "api.wayfinder.example.com"
  wayfinder_domain_name_ui                = "portal.wayfinder.example.com"

  vpc_tags                                = {
    "Name" = "wayfinder-prod"
  }

  subnet_tags                             = {
    "Tier" = "Private"
  }

  cluster_security_group_additional_rules = {
    allow_access_from_vpn = {
      description = "Allow access to the Wayfinder API from the Example Org VPN"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }
}
