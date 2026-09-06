
# INTERNAL ALB
variable "internal_alb_name" {
  type    = string
  default = "r-internal-alb"
}

variable "internal_security_group_id" {
  type = string
}

variable "internal_alb_tg_name" {
  type    = string
  default = "r-internal-tg"
}

variable "target_backend_instance_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "certificate_arn" {
  type = string
}

# GLOBAL TAG
variable "tags" {
  type = map(string)
  default = {
    Project   = "recall"
    Terraform = true
  }
}


