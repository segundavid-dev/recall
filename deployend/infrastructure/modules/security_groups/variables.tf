
variable "vpc_id" {
  type = string
}

variable "frontend_sg_name" {
  type    = string
  default = "r-fronted-sg"
}

variable "backend_sg_name" {
  type    = string
  default = "r-backend-sg"
}

variable "alb_sg_name" {
  type    = string
  default = "r-alb-sg"
}

variable "bastion_host_sg_name" {
  type    = string
  default = "r-bastion-host-sg"
}

variable "internal_alb_sg_name" {
  type    = string
  default = "r-internal-alb-sg"
}

variable "vpc_link_sg_name" {
  type    = string
  default = "r-vpc-link-sg"
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
