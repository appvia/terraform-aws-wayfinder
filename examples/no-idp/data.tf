data "aws_caller_identity" "current" {}

data "aws_route53_zone" "selected" {
  name = var.dns_zone_name
}

data "aws_secretsmanager_secret" "wayfinder" {
  name = var.aws_secretsmanager_name
}

data "aws_secretsmanager_secret_version" "wayfinder" {
  secret_id = data.aws_secretsmanager_secret.wayfinder.id
}
