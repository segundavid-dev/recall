data "aws_route53_zone" "existing_hosted_zone" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "cloudfront_root" {
  zone_id = data.aws_route53_zone.existing_hosted_zone.zone_id
  name    = var.hosted_zone_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront_www" {
  zone_id = data.aws_route53_zone.existing_hosted_zone.zone_id
  name    = "${var.project_name}.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = var.certificate_arn

  validation_record_fqdns = [
    for record in aws_route53_record.acm_validation :
    record.fqdn
  ]
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in var.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.existing_hosted_zone.id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]
}




resource "aws_route53_record" "backend" {
  zone_id = data.aws_route53_zone.existing_hosted_zone.zone_id

  name = "internal.${var.project_name}.${var.hosted_zone_name}"
  type = "A"

  alias {
    name                   = var.internal_alb_dns_name
    zone_id                = var.internal_alb_zone_id
    evaluate_target_health = false
  }
}