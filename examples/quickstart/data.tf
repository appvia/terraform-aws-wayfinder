data "aws_caller_identity" "current" {}

data "aws_route53_zone" "selected" {
  name = var.dns_zone_name
}
