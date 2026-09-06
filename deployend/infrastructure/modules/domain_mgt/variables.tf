variable "hosted_zone_name" {
  description = "Existing Route 53 hosted zone."
  type        = string
}


variable "domain_validation_options" {
  description = "The domain validation options for the ACM certificate."
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}

variable "vpc_id" {
  type = string
}


variable "cloudfront_domain_name" {
  type = string
}

variable "cloudfront_hosted_zone_id" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "internal_alb_dns_name" {
  type = string
}

variable "internal_alb_zone_id" {
  type = string
}

variable "project_name" {
  type = string
}
# -------------------------------------------------------
# GLOBAL TAGS
# -------------------------------------------------------
variable "tags" {
  type = map(string)
  default = {
    Project   = "recall"
    Terraform = true
  }
}