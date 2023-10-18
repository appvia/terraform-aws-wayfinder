module "wayfinder_cloudaccess" {
  source = "../../"

  resource_suffix                 = "app1-nonprod"
  wayfinder_identity_aws_role_arn = "arn:aws:iam::123456789012:role/wf-cloudidentity-aws"
  enable_cluster_manager          = true
  enable_dns_zone_manager         = true
  enable_network_manager          = true
  enable_cloud_info               = false
}
