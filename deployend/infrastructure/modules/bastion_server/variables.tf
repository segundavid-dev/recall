variable "instance_name" {
  type    = string
  default = "r-bastion-server"
}

variable "ami" {
  type    = string
  default = "ami-0f8a61b66d1accaee"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "security_group_ids" {
  type = list(string)
}

variable "public_subnet_id" {
  type = string
}

variable "bastion_key_name" {
  type = string
}

variable "bastion_public_key_name" {
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