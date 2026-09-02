# PROVIDER
# -------------------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}


# EC2 INSTANCE
# -------------------------------------------------------------------------------------
resource "aws_instance" "tmp_frontend_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.this.key_name
  availability_zone      = var.availability_zone
  vpc_security_group_ids = [aws_security_group.tmp_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_s3.name


  root_block_device {
    volume_size = 8
    volume_type = "gp3"

    delete_on_termination = true

    tags = merge(var.tags, {
      Name = "${var.frontend_server_name}-volume"
    })
  }

  tags = merge(var.tags, {
    Name = var.frontend_server_name
  })
}

resource "aws_instance" "tmp_backend_server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.this.key_name
  availability_zone      = var.availability_zone
  vpc_security_group_ids = [aws_security_group.tmp_sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"

    delete_on_termination = true

    tags = merge(var.tags, {
      Name = "${var.backend_server_name}-volume"
    })
  }

  tags = merge(var.tags, {
    Name = var.backend_server_name
  })
}


# KEY PAIR
# -------------------------------------------------------------------------------------
resource "aws_key_pair" "this" {
  key_name   = "tmp_sv_key"
  public_key = file("${path.root}/.ssh_keys/tmp_sv_key.pub")
}


# Gets my current IPv4 address
# -------------------------------------------------------------------------------------
terraform {
  required_providers {
    http = {
      source = "hashicorp/http"
    }
  }
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  my_ip = "${trimspace(data.http.my_ip.response_body)}/32"
}


# Security Group Configuration for EC2 Instance
# -------------------------------------------------------------------------------------
resource "aws_security_group" "tmp_sg" {
  name        = "recall_sg_tmp"
  description = "Security group for recall_tmp_server"

  tags = var.security_group_tags
}

resource "aws_vpc_security_group_ingress_rule" "ssh_access" {
  security_group_id = aws_security_group.tmp_sg.id
  cidr_ipv4         = local.my_ip
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "http_access_ipv4" {
  security_group_id = aws_security_group.tmp_sg.id
  cidr_ipv4         = local.my_ip
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "all_outbound_ipv4" {
  security_group_id = aws_security_group.tmp_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# IAM Policy
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-download-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ec2_s3_download" {
  name = "ec2-s3-download-policy"
  role = aws_iam_role.ec2_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject"
        ]

        Resource = "arn:aws:s3:::recall-frontend/*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::recall-frontend"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_s3" {
  name = "ec2-s3-download-profile"

  role = aws_iam_role.ec2_s3_role.name
}