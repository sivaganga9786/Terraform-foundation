# Fetch App-tier EC2 instances automatically
data "aws_instances" "app_instances" {
  filter {
    name   = "tag:${var.app_tag_key}"
    values = [var.app_tag_value]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# Internal ALB using existing security group
resource "aws_lb" "internal" {
  name               = "${var.name}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.internal_alb_sg_ids
  subnets            = var.private_subnets

  enable_deletion_protection = false

  tags = {
    Name = "${var.name}-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "app_tg" {
  name        = "${var.name}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "${var.name}-tg"
  }
}

# Attach App instances to Target Group
resource "aws_lb_target_group_attachment" "app_attach" {
  for_each         = toset(data.aws_instances.app_instances.ids)
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = each.value
  port             = var.app_port
}

# Listener for Internal ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 4000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Outputs
output "alb_arn" {
  value = aws_lb.internal.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "app_instance_ids" {
  value = data.aws_instances.app_instances.ids
}
