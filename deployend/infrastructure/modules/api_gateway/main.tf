
# -------------------------------------------------------
# Internal ALB (Application Load Balancer)
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
    path                = "/" # Ensure your app responds 200 OK here
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

resource "aws_lb_listener" "http_internal" {
   load_balancer_arn = aws_lb.internal_alb.arn
  port              = 8001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_alb_tg.arn
  }
}

# # -------------------------------------------------------
# # Public-Facing ALB
# # -------------------------------------------------------
# resource "aws_lb" "internal_alb" {
#   name               = var.internal_alb_name
#   internal           = false # Internet-facing
#   load_balancer_type = "application"

#   security_groups = [
#     var.internal_security_group_id
#   ]

#   # Internet-facing ALBs must use Public Subnets
#   subnets = var.private_subnet_ids

#   tags = merge(
#     { Name = var.internal_alb_name }, var.tags
#   )
# }

# resource "aws_lb_target_group" "alb_tg" {
#   name        = var.internal_alb_tg_name
#   port        = 8001
#   protocol    = "HTTP"
#   target_type = "instance"
#   vpc_id      = var.vpc_id

#   health_check {
#     enabled             = true
#     path                = "/" # Ensure your app responds 200 OK here
#     protocol            = "HTTP"
#     port                = "8001"
#     matcher             = "200"
#     interval            = 30
#     timeout             = 5
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }

#   tags = merge(
#     { Name = var.internal_alb_tg_name }, var.tags
#   )
# }

# resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
#   target_group_arn = aws_lb_target_group.alb_tg.arn
#   target_id        = var.target_backend_instance_id
#   port             = 8001
# }

# # Listener configured on PORT 8001 to receive frontend traffic
# resource "aws_lb_listener" "http_8001" {
#   load_balancer_arn = aws_lb.internal_alb.arn
#   port              = 8001
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_tg.arn
#   }
# }