# Application Load Balancer
resource "aws_lb" "goosetunetv" {
  name               = "goosetunetv-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.terraform_remote_state.network.outputs.alb_security_group_id]
  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "goosetunetv-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "goosetunetv" {
  name     = "goosetunetv-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.network.outputs.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "goosetunetv-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "goosetunetv" {
  load_balancer_arn = aws_lb.goosetunetv.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.terraform_remote_state.security.outputs.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.goosetunetv.arn
  }
}

# Route53 A record for goosetune.tv pointing to ALB
resource "aws_route53_record" "goosetune_tv_root" {
  zone_id = data.terraform_remote_state.security.outputs.hosted_zone_id
  name    = "goosetune.tv"
  type    = "A"

  alias {
    name                   = aws_lb.goosetunetv.dns_name
    zone_id                = aws_lb.goosetunetv.zone_id
    evaluate_target_health = true
  }
}

