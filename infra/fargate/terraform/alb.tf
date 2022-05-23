
data "aws_subnet" "public" {
  vpc_id = var.vpc_id

  tags = {
    Type = "Public"
  }
}


resource "aws_alb" "alb" {
  name            = var.naming
  subnets         = data.aws_subnet.public.ids
  security_groups = [aws_security_group.sg_lb.id]
  tags          = {
    Name  = "${var.naming}-loadbalance"
    Owner = var.tag_owner
  }
}
resource "aws_alb_target_group" "targetgroup" {
  name        = "${var.naming}-tg"
  port        = var.docker_image_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id
  target_type = "ip"
  health_check {
    protocol            = "HTTP"
    path                = var.healthcheck
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    timeout             = "5"
    interval            = "30"
    matcher             = "200"
  }
  tags          = {
    Name  = "${var.naming}-targetgroup"
    Owner = var.tag_owner
  }
}
data "aws_acm_certificate" "https" {
  domain   = var.https_domain_name
  statuses = ["ISSUED"]
}
resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.port_https
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-2019-08"
  certificate_arn   = data.aws_acm_certificate.https.arn
  default_action {
    target_group_arn = aws_alb_target_group.targetgroup.id
    type             = "forward"
  }
}

