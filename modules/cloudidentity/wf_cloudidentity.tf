resource "aws_iam_user" "cloudidentity" {
  name = "wf-cloudidentity${local.resource_suffix}"
  path = "/"
}

resource "aws_iam_access_key" "cloudidentity" {
  user = aws_iam_user.cloudidentity.name
}

data "aws_iam_policy_document" "cloudidentity" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/wf-*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["aws-marketplace:MeterUsage"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "cloudidentity" {
  name   = "wf-cloudidentity${local.resource_suffix}"
  user   = aws_iam_user.cloudidentity.name
  policy = data.aws_iam_policy_document.cloudidentity.json
}