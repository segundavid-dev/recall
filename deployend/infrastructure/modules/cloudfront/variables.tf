variable "origin_domain_name" {
  type = string
}

variable "aliases" {
  type    = list(string)
}

variable "acm_certificate_arn" {
  type = string
}