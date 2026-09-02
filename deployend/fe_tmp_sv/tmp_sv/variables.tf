variable "ami" {
  type    = string
  default = "ami-0b6d9d3d33ba97d99"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "availability_zone" {
  type    = string
  default = "us-east-1c"
}


variable "security_group_tags" {
  type = map(string)
  default = {
    Name      = "recall_tmp_sg"
    Project   = "recall"
    Terraform = "true"
  }
}

variable "backend_server_name" {
  type    = string
  default = "r-tmp-backend-server"
}

variable "frontend_server_name" {
  type    = string
  default = "r-tmp-frontend-server"
}

# GLOBAL TAG
variable "tags" {
  type = map(string)
  default = {
    Project   = "recall"
    Terraform = true
  }
}







