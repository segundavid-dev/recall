
# -------------------------------------------------------
# Internal ALB (Application Load Balancer) or Backend ALB 
# (It is an internet facing ALB so that frontend can reach the backend through the Loadbalancer
# while the backend server remains in private subnet)
# -------------------------------------------------------
resource "aws_lb" "internal_alb" {
  name               = var.internal_alb_name
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.internal_security_group_id
  ]

  subnets = var.private_subnet_ids

  tags = merge(
  { Name = var.internal_alb_name }, var.tags)
}

resource "aws_lb_target_group" "internal_alb_tg" {
  name        = var.internal_alb_tg_name
  port        = 8001
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = "/" 
    protocol            = "HTTP"
    port                = "8001"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(
    { Name = var.internal_alb_tg_name }, var.tags
  )
}

resource "aws_lb_target_group_attachment" "internal_alb_tg_attachment" {
  target_group_arn = aws_lb_target_group.internal_alb_tg.arn
  target_id        = var.target_backend_instance_id
  port             = 8001
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_alb_tg.arn
  }
}

