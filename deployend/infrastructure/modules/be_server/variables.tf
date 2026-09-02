variable "instance_name" {
  type    = string
  default = "r-backend-server"
}

variable "ami" {
  type    = string
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}


variable "security_group_ids" {
  type = list(string)
}

variable "private_subnet_id" {
  type = string
}

variable "backend_key_name" {
  type = string
}

variable "backend_public_key_name" {
  type = string
}

# GLOBAL TAGS
variable "tags" {
  type = map(string)

  default = {
    Project   = "recall"
    Terraform = "true"
  }
}