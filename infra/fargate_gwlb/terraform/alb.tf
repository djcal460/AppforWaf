data "aws_subnet_ids" "public" {
  vpc_id = var.vpc_id
  tags = {
    Type = var.tag_public
  }
}
resource "aws_alb" "alb" {
  name            = var.naming
  subnets         = data.aws_subnet_ids.public.ids
  security_groups = [aws_security_group.sg_lb.id]
  tags          = {
    Name  = "${var.naming}-loadbalance"
    Owner = var.tag_owner
  }
}

resource "aws_lb gateway_lb" "gwlb" {
  load_balancer_type = "gateway"
  name               = "gwlb"
  enable_cross_zone_load_balancing = true
  subnet_mapping {
    subnet_id = aws_subnet.sec2-sub.id
  }
     tags = {
    Name = "my-gateway-load-balancer"
  }
  
  }

resource "aws_lb_target_group" "mygwlb-target" {
  name     = "${var.naming}-tg"
  port     = var.docker_image_port
  protocol = "GENEVE"
  vpc_id   = aws_vpc.main3.id
  target_type = "instance"


  health_check {
    port     = 22
    protocol = "TCP"
   
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

