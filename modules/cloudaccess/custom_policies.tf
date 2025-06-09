module "custom_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.45.0"

  for_each = { for idx, policy in var.custom_policy_documents : idx => policy }

  name        = "wf-CustomPolicy${each.key + 1}${local.resource_suffix}"
  description = "Custom IAM policy created by Wayfinder"
  policy      = each.value
  tags        = var.tags
}