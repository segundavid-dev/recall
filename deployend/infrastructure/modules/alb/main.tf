# -------------------------------------------------------
# ALB (Application Load Balancer)
# -------------------------------------------------------
resource "aws_lb" "alb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.security_group_id
  ]

  subnets = var.public_subnet_ids

  tags = var.tags
}

resource "aws_lb_target_group" "alb_tg" {

  name        = "${var.name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  vpc_id = var.vpc_id

  health_check {
    enabled = true

    path = "/"

    protocol = "HTTP"

    matcher = "200"
  }

  tags = var.tags
}

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}



# -------------------------------------------------------
# AUTO SCALING GROUP
# -------------------------------------------------------
resource "aws_autoscaling_group" "autoscaling_group" {
  name = var.asg_name

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  health_check_type         = "ELB"
  health_check_grace_period = 300

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [aws_lb_target_group.alb_tg.arn]

  launch_template {
    id      = var.launch_template_id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}




