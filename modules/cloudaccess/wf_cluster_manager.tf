module "iam_role_cluster_manager" {
  count = var.create_cluster_manager_role ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.17.0"

  create_role             = true
  role_name               = "wf-ClusterManager${local.resource_suffix}"
  role_description        = "Create and manage EKS Kubernetes clusters"
  role_requires_mfa       = false
  custom_role_policy_arns = [module.iam_policy_cluster_manager[0].arn]
  trusted_role_arns       = [var.wayfinder_iam_role_arn]
}

module "iam_policy_cluster_manager" {
  count = var.create_cluster_manager_role ? 1 : 0

  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.17.0"

  name        = "wf-ClusterManager${local.resource_suffix}"
  description = "Create and manage EKS Kubernetes clusters"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateLaunchTemplate",
        "ec2:CreateLaunchTemplateVersion",
        "ec2:CreateTags",
        "ec2:DeleteLaunchTemplate",
        "ec2:DescribeKeyPairs",
        "ec2:DescribeLaunchTemplates",
        "ec2:DescribeLaunchTemplateVersions",
        "ec2:DescribeSecurityGroups",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RunInstances",
        "eks:AccessKubernetesApi",
        "eks:CreateCluster",
        "eks:CreateNodegroup",
        "eks:DeleteCluster",
        "eks:DeleteNodegroup",
        "eks:DescribeCluster",
        "eks:DescribeNodegroup",
        "eks:ListNodegroups",
        "eks:TagResource",
        "eks:UpdateClusterConfig",
        "eks:UpdateClusterVersion",
        "eks:UpdateNodegroupConfig",
        "eks:UpdateNodegroupVersion",
        "kms:CreateAlias",
        "kms:CreateKey",
        "kms:DeleteAlias",
        "kms:DescribeKey",
        "kms:ListAliases",
        "kms:ListKeys",
        "kms:ListResourceTags",
        "kms:ScheduleKeyDeletion",
        "kms:TagResource",
        "kms:UpdateAlias"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "eks:CreateAddon",
        "eks:DescribeAddon",
        "eks:DescribeAddonVersions",
        "eks:ListAddons",
        "eks:UpdateAddon"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "iam:PassRole"
      ],
      "Condition": {
        "StringEquals": {
          "iam:PassedToService": [
            "eks.amazonaws.com"
          ]
        }
      },
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "iam:AttachRolePolicy",
        "iam:CreateOpenIDConnectProvider",
        "iam:CreateRole",
        "iam:CreateServiceLinkedRole",
        "iam:DeleteOpenIDConnectProvider",
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "iam:DetachRolePolicy",
        "iam:GetOpenIDConnectProvider",
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:GetUser",
        "iam:ListAttachedRolePolicies",
        "iam:ListRolePolicies",
        "iam:PutRolePolicy",
        "iam:TagOpenIDConnectProvider",
        "iam:TagRole",
        "iam:UpdateAssumeRolePolicy",
        "iam:UpdateOpenIDConnectProviderThumbprint",
        "iam:UpdateRoleDescription"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ec2:CreateTags",
        "ec2:DescribeInstances",
        "ec2:DescribeSubnets"
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
        "iam:CreatePolicy*",
        "iam:DeletePolicy*",
        "iam:GetPolicy*",
        "iam:ListPolicyVersions"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::*:policy/wf-*"
      ]
    }
  ]
}
EOF
}
