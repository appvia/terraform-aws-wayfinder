module "iam_assumable_role_dns_zone_manager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.17.0"

  create_role             = true
  role_name               = "wf-DNSZoneManager-${var.wayfinder_instance_id}"
  role_description        = "Create and manage Route 53 DNS Zones for automated DNS management"
  role_requires_mfa       = false
  custom_role_policy_arns = [module.iam_policy_dns_zone_manager.arn]
  trusted_role_arns       = [module.wayfinder_irsa_role.iam_role_arn]
  tags                    = local.tags
}

module "iam_policy_dns_zone_manager" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.17.0"

  name        = "wf-DNSZoneManager-${var.wayfinder_instance_id}"
  description = "Create and manage Route 53 DNS Zones for automated DNS management"
  tags        = local.tags

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "route53:ListHostedZones",
        "route53:GetHostedZone",
        "route53:CreateHostedZone",
        "route53:DeleteHostedZone",
        "route53:ChangeTagsForResource",
        "route53:ListResourceRecordSets",
        "route53:ChangeResourceRecordSets",
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
        "iam:GetRole",
        "iam:CreateRole",
        "iam:TagRole",
        "iam:UpdateRoleDescription",
        "iam:UpdateAssumeRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:PutRolePolicy"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

module "iam_assumable_role_cloud_info" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.17.0"

  create_role             = true
  role_name               = "wf-CloudInfo-${var.wayfinder_instance_id}"
  role_description        = "Retrieve pricing information for AWS cloud resources"
  role_requires_mfa       = false
  custom_role_policy_arns = [module.iam_policy_cloud_info.arn]
  trusted_role_arns       = [module.wayfinder_irsa_role.iam_role_arn]
  tags                    = local.tags
}

module "iam_policy_cloud_info" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.17.0"

  name        = "wf-CloudInfo-${var.wayfinder_instance_id}"
  description = "Retrieve pricing information for AWS cloud resources"
  tags        = local.tags

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "pricing:GetAttributeValues",
        "pricing:GetProducts",
        "pricing:DescribeServices"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ec2:DescribeRegions",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeImages",
        "ec2:DescribeSpotPriceHistory"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "kubectl_manifest" "wayfinder_aws_admin_cloudaccessconfig" {
  count = var.enable_k8s_resources ? 1 : 0

  depends_on = [
    helm_release.wayfinder,
  ]

  yaml_body = templatefile("${path.module}/manifests/wayfinder-aws-admin-cloudaccessconfig.yml.tpl", {
    region                    = data.aws_region.current.name
    account_id                = data.aws_caller_identity.current.account_id
    dns_zone_manager_role_arn = module.iam_assumable_role_dns_zone_manager.iam_role_arn
    cloud_info_role_arn       = module.iam_assumable_role_cloud_info.iam_role_arn
    identifier                = var.wayfinder_instance_id
  })
}
