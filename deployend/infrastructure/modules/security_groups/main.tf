# -------------------------------------------------------------------------------------
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



# -------------------------------------------------------------------------------------
# FRONTEND SERVERS
# -------------------------------------------------------------------------------------
resource "aws_security_group" "frontend_sg" {
  name        = var.frontend_sg_name
  description = "Security group for frontend servers"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = var.frontend_sg_name
  })
}

resource "aws_vpc_security_group_ingress_rule" "ssh_access" {
  security_group_id            = aws_security_group.frontend_sg.id
  referenced_security_group_id = aws_security_group.bastion_host_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

resource "aws_vpc_security_group_ingress_rule" "http_access_ipv4" {
  security_group_id            = aws_security_group.frontend_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "all_outbound_ipv4" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "all_outbound_ipv6" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}



# -------------------------------------------------------------------------------------
# APPLICATION LOADBALANCER (ALB) 
# -------------------------------------------------------------------------------------
resource "aws_security_group" "alb_sg" {
  name        = var.alb_sg_name
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(var.tags,
    {
      Name = var.alb_sg_name
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_access_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_access_ipv6" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_all_outbound_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}







# -------------------------------------------------------------------------------------
# BASTION HOST
# -------------------------------------------------------------------------------------
resource "aws_security_group" "bastion_host_sg" {
  name        = var.bastion_host_sg_name
  description = "Security group for Bastion Host"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "r-bastion-host-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "bh_ssh_access" {
  security_group_id = aws_security_group.bastion_host_sg.id
  cidr_ipv4         = local.my_ip
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "bh_outbound_ipv4" {
  security_group_id = aws_security_group.bastion_host_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "bh_outbound_ipv6" {
  security_group_id = aws_security_group.bastion_host_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}


# -------------------------------------------------------------------------------------
# BACKEND SERVER
# -------------------------------------------------------------------------------------
resource "aws_security_group" "backend_sg" {
  name        = var.backend_sg_name
  description = "Security group for backend server"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags, {
      Name = var.backend_sg_name
  })
}

resource "aws_vpc_security_group_ingress_rule" "be_ssh_access" {
  security_group_id            = aws_security_group.backend_sg.id
  referenced_security_group_id = aws_security_group.bastion_host_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

resource "aws_vpc_security_group_ingress_rule" "be_http_access_ipv4" {
  security_group_id            = aws_security_group.backend_sg.id
  referenced_security_group_id = aws_security_group.internal_alb_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 8001
  to_port                      = 8001
}

resource "aws_vpc_security_group_egress_rule" "be_outbound_ipv4" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "be_all_outbound_ipv6" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}


# -------------------------------------------------------------------------------------
# INTERNAL APPLICATION LOADBALANCER (ALB) 
# -------------------------------------------------------------------------------------
resource "aws_security_group" "internal_alb_sg" {
  name        = var.internal_alb_sg_name
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(var.tags,
    {
      Name = var.internal_alb_sg_name
  })
}

resource "aws_vpc_security_group_ingress_rule" "internal_alb_http_access_ipv4" {
  security_group_id            = aws_security_group.internal_alb_sg.id
  referenced_security_group_id = aws_security_group.frontend_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 8001
  to_port                      = 8001
}


resource "aws_vpc_security_group_egress_rule" "internal_alb_all_outbound_ipv4" {
  security_group_id = aws_security_group.internal_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


