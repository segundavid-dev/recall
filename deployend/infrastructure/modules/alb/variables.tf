# -------------------------------------------------------
# ALB
# -------------------------------------------------------
variable "name" {
  type    = string
  default = "r-alb"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}



# -------------------------------------------------------
# AUTOSCALING GROUP
# -------------------------------------------------------
variable "asg_name" {
  type    = string
  default = "r_asg"
}

variable "launch_template_id" {
  type = string
}


variable "instance_name" {
  type    = string
  default = "r_frontend_server"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "tags" {
  type = map(string)
  default = {
    Project   = "recall"
    Terraform = true
  }
}