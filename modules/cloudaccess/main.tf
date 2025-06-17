locals {
  resource_suffix   = var.resource_suffix != "" ? "-${var.resource_suffix}" : ""
  azure_oidc_issuer = var.wayfinder_identity_azure_tenant_id != "" ? "https://sts.windows.net/${var.wayfinder_identity_azure_tenant_id}/" : ""

  enabled_policies = concat(
    var.enable_cluster_manager_permissions ? [module.iam_policy_cluster_manager[0].arn] : [],
    var.enable_dns_zone_manager_permissions ? [module.iam_policy_dns_zone_manager[0].arn] : [],
    var.enable_network_manager_permissions ? [module.iam_policy_network_manager[0].arn] : [],
    var.enable_peering_acceptor_permissions ? [module.iam_policy_peering_acceptor[0].arn] : [],
    var.enable_cloud_info_permissions ? [module.iam_policy_cloud_info[0].arn] : [],
    var.custom_policy_arns,
    [for policy in module.custom_policies : policy.arn]
  )
}
