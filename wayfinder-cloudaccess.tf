module "wayfinder_cloudaccess" {
  count  = var.enable_wf_cloudaccess && (var.enable_wf_dnszonemanager || var.enable_wf_costestimates) ? 1 : 0
  source = "./modules/cloudaccess"

  resource_suffix                 = var.wayfinder_instance_id
  wayfinder_identity_aws_role_arn = module.wayfinder_irsa_role.iam_role_arn
  enable_dns_zone_manager         = var.enable_wf_dnszonemanager
  enable_cloud_info               = var.enable_wf_costestimates
  tags                            = local.tags
}

resource "kubectl_manifest" "wayfinder_cloud_identity_main" {
  count      = var.enable_k8s_resources && var.enable_wf_cloudaccess ? 1 : 0
  depends_on = [helm_release.wayfinder]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-cloud-identity.yml.tpl", {
    name        = "cloudidentity-aws"
    description = "Wayfinder's AWS IRSA identity configured at install"
    role_arn    = module.wayfinder_irsa_role.iam_role_arn
  })
}

resource "kubectl_manifest" "wayfinder_aws_cloudinfo_cloudaccessconfig" {
  count = var.enable_k8s_resources && var.enable_wf_cloudaccess && var.enable_wf_costestimates ? 1 : 0

  depends_on = [
    helm_release.wayfinder,
    kubectl_manifest.wayfinder_cloud_identity_main,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-aws-cloudaccessconfig.yml.tpl", {
    account_id  = data.aws_caller_identity.current.account_id
    description = "Used for cost data retrieval in order to provide infrastructure cost estimates."
    identity    = "cloudidentity-aws"
    name        = "aws-cloudinfo"
    permission  = "CloudInfo"
    region      = data.aws_region.current.name
    role_arn    = module.wayfinder_cloudaccess[0].cloud_info_role_arn
    type        = "CostEstimates"
  })
}

resource "kubectl_manifest" "wayfinder_aws_dnszonemanager_cloudaccessconfig" {
  count = var.enable_k8s_resources && var.enable_wf_cloudaccess && var.enable_wf_dnszonemanager ? 1 : 0

  depends_on = [
    helm_release.wayfinder,
    kubectl_manifest.wayfinder_cloud_identity_main,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-aws-cloudaccessconfig.yml.tpl", {
    account_id  = data.aws_caller_identity.current.account_id
    description = "Used for managing a top-level domain, so that Wayfinder can create sub domains within it that are delegated to workspace clusters."
    identity    = "cloudidentity-aws"
    name        = "aws-dnsmanagement"
    permission  = "DNSZoneManager"
    region      = data.aws_region.current.name
    role_arn    = module.wayfinder_cloudaccess[0].dns_zone_manager_role_arn
    type        = "DNSZoneManagement"
  })
}
