
# -------------------------------------------------------
# Internal ALB (Application Load Balancer)
# -------------------------------------------------------
resource "aws_lb" "internal_alb" {
  name               = var.internal_alb_name
  internal           = true
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

  vpc_id = var.vpc_id

  health_check {
    enabled  = true
    path     = "/"
    protocol = "HTTP"
    matcher  = "200"
  }

  tags = merge(
  { Name = var.internal_alb_tg_name }, var.tags)
}

resource "aws_lb_target_group_attachment" "internal_alb_tg_attachment" {
  target_group_arn = aws_lb_target_group.internal_alb_tg.arn

  target_id = var.target_backend_instance_id
  port      = 8001
}

resource "aws_lb_listener" "http_internal" {
  load_balancer_arn = aws_lb.internal_alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.internal_alb_tg.arn
  }
}
