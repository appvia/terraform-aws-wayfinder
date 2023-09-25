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
  wayfinder_instance_id     = var.wayfinder_instance_id
  wayfinder_licence_key     = var.wayfinder_licence_key
}
