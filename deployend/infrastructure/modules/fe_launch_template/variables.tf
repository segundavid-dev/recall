# -------------------------------------------------------
# AMI
# -------------------------------------------------------
variable "frontend_ami_name" {
  type    = string
  default = "r-frontend-ami"
}

variable "frontend_instance_id" {
  type = string
}

variable "backend_ami_name" {
  type    = string
  default = "r-backend-ami"
}

variable "backend_instance_id" {
  type = string
}

# -------------------------------------------------------
# LAUNCH TEMPLATE
# -------------------------------------------------------
variable "lt_name" {
  type    = string
  default = "r-launch-template"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "security_group_ids" {
  type = list(string)
}

variable "frontend_key_name" {
  type = string
}

variable "frontend_public_key_name" {
  type = string
}

variable "instance_name" {
  type    = string
  default = "r-frontend-server"
}

variable "vpc_id" {
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
