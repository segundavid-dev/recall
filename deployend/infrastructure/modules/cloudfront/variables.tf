variable "origin_domain_name" {
  type = string
}

variable "aliases" {
  type    = list(string)
  default = ["www.chisom.biz"]
}

variable "acm_certificate_arn" {
  type = string
}