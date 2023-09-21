module "iam_role_dns_zone_manager" {
  count = var.create_dns_zone_manager_role ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.17.0"

  create_role                   = true
  role_name                     = "wf-DNSZoneManager${local.resource_suffix}"
  role_description              = "Create and manage Route 53 DNS Zones for automated DNS management"
  role_requires_mfa             = false
  custom_role_policy_arns       = [module.iam_policy_dns_zone_manager[0].arn]
  trusted_role_arns             = [var.wayfinder_iam_role_arn]
  role_permissions_boundary_arn = var.permissions_boundary_policy_arn
}

module "iam_policy_dns_zone_manager" {
  count = var.create_dns_zone_manager_role ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.17.0"

  name        = "wf-DNSZoneManager${local.resource_suffix}"
  description = "Create and manage Route 53 DNS Zones for automated DNS management"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ChangeTagsForResource",
        "route53:CreateHostedZone",
        "route53:DeleteHostedZone",
        "route53:GetHostedZone",
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "route53:ListTagsForResource"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "sts:GetCallerIdentity"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "iam:CreateRole",
        "iam:DeleteRolePolicy",
        "iam:GetRole",
        "iam:PutRolePolicy",
        "iam:TagRole",
        "iam:UpdateAssumeRolePolicy",
        "iam:UpdateRoleDescription"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
