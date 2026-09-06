resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = ["internal.${var.project_name}.${var.domain_name}", "${var.project_name}.${var.domain_name}"]
  validation_method         = var.validation_method

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags, {
      Name = var.cert_name
  })
}