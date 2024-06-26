
locals {
  # Just extra safety incase someone passes in a url with `https://`
  provider_url               = replace(var.provider_url, "https://", "")
  number_of_role_policy_arns = length(var.role_policy_arns)
}

################################################################################
# Google OIDC Role
################################################################################

data "aws_iam_policy_document" "this" {
  count = var.create ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = [local.provider_url]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.provider_url}:sub"
      values   = var.google_service_account_ids
    }

    condition {
      test     = "StringEquals"
      variable = "${local.provider_url}:email"
      values   = var.google_service_account_emails
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create ? 1 : 0

  name        = var.name
  name_prefix = var.name_prefix
  path        = var.path
  description = var.description

  assume_role_policy    = data.aws_iam_policy_document.this[0].json
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary_arn
  force_detach_policies = var.force_detach_policies
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = var.create ? local.number_of_role_policy_arns : 0

  role       = aws_iam_role.this[0].name
  policy_arn = var.role_policy_arns[count.index]
}
