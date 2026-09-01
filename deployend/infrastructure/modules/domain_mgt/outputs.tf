output "validated_certificate_arn" {
  value = aws_acm_certificate_validation.this.certificate_arn
}
# output "validation_record_fqdns" {
#   value = [for r in aws_route53_record.acm_validation : r.fqdn]
# }