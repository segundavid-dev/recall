#VPC
variable "vpc_name" {
  type    = string
  default = "r-VPC"
}


variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}


#PRIVATE SUBNETS
variable "private_subnets_name" {
  type = list(string)
  default = [
    "r-private-a1-subnet",
    "r-private-b1-subnet",
    "r-private-c1-subnet"
  ]
}

variable "private_subnets_cidr_block" {
  type = list(string)
  default = [
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24"
  ]
}

variable "private_subnets_az" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
}



#PUBLIC SUBNETS
variable "public_subnets_name" {
  type = list(string)
  default = [
    "r-public-a1-subnet",
    "r-public-b1-subnet",
    "r-public-c1-subnet",
    "r-public-d1-subnet"
  ]
}

variable "public_subnets_cidr_block" {
  type = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "public_subnets_az" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d"
  ]
}



# GLOBAL TAGS
variable "tags" {
  type = map(string)

  default = {
    Project   = "recall"
    Terraform = "true"
  }
}




variable "internet_gateway_name" {
  type    = string
  default = "r-igw"
}

variable "public_route_table_name" {
  type    = string
  default = "r-public-rt"
}

variable "private_route_table_name" {
  type    = string
  default = "r-private-rt"
}

variable "nat_gateway_name" {
  type    = string
  default = "r-nat-g"
}

variable "elastic_ip_name" {
  type    = string
  default = "r-elastic-1p"
}
