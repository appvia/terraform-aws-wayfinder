module "wayfinder" {
  source = "../../"

  clusterissuer_email       = var.clusterissuer_email
  create_localadmin_user    = true
  disable_internet_access   = var.disable_internet_access
  dns_zone_arn              = data.aws_route53_zone.selected.arn
  environment               = var.environment
  kms_key_administrators    = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  subnet_ids                = module.vpc.private_subnets
  tags                      = var.tags
  vpc_id                    = module.vpc.vpc_id
  wayfinder_domain_name_api = "api.${var.dns_zone_name}"
  wayfinder_domain_name_ui  = "portal.${var.dns_zone_name}"
  wayfinder_license_key     = jsondecode(data.aws_secretsmanager_secret_version.wayfinder.secret_string)["licenseKey"]

  # cluster_security_group_additional_rules = {
  #   allow_access_from_vpn = {
  #     description = "Allow access to the Wayfinder API from within My Organisation's internal network"
  #     protocol    = "tcp"
  #     from_port   = 443
  #     to_port     = 443
  #     type        = "ingress"
  #     cidr_blocks = ["10.0.0.0/8"]
  #   }
  # }
}
