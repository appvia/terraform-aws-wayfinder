module "wayfinder_cloudaccess" {
  source = "../"

  instance_id            = "5241db7bb541"
  wayfinder_iam_role_arn = "arn:aws:iam::123456789012:role/wayfinder"
  workspace_id           = "appt1"
}
