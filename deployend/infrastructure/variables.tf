
variable "bastion_key_name" {
  description = "Name of the bastion host SSH key pair"
  type        = string
}

variable "bastion_public_key_path" {
  description = "Path to the bastion host public SSH key"
  type        = string
}

variable "backend_key_name" {
  description = "Name of the backend server SSH key pair"
  type        = string
}

variable "backend_public_key_path" {
  description = "Path to the backend server public SSH key"
  type        = string
}


variable "frontend_key_name" {
  description = "Name of the frontend server SSH key pair"
  type        = string
}

variable "frontend_public_key_path" {
  description = "Path to the frontend server public SSH key"
  type        = string
}

