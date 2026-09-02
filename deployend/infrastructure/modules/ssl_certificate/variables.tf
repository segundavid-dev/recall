variable "domain_name" {
  type = string
}


variable "validation_method" {
  type    = string
  default = "DNS"
}

variable "cert_name" {
  type    = string
  default = "ssl_cert"
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
