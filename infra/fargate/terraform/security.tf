# Security Group for ALB
resource "aws_security_group" "sg_lb" {
  name        = "${var.naming}-alb-sg"
  description = "Allow all internet traffic to ALB"
  vpc_id      = data.aws_vpc.selected.id
  ingress {
    protocol    = var.protocol_tcp
    from_port   = var.port_https
    to_port     = var.port_https
    cidr_blocks = [var.cidr_ipv4_all]
  }
  egress {
    protocol    = var.protocol_all
    from_port   = var.ports_all
    to_port     = var.ports_all
    cidr_blocks = [var.cidr_ipv4_all]
  }
  tags          = {
    Name  = "${var.naming}-loadbalancer-securitygroup"
    Owner = var.tag_owner
  }
}
# Security Group for ECS Tasks
resource "aws_security_group" "sg_ecs_tasks" {
  name        = "${var.naming}-ecstask-sg"
  description = "Allow inbound access from the ALB only"
  vpc_id      = data.aws_vpc.selected.id
  ingress {
    protocol        = var.protocol_tcp
    from_port       = var.docker_image_port
    to_port         = var.docker_image_port
    security_groups = [aws_security_group.sg_lb.id]
  }
  egress {
    protocol    = var.protocol_all
    from_port   = var.ports_all
    to_port     = var.ports_all
    cidr_blocks = [var.cidr_ipv4_all]
  }
  tags          = {
    Name  = "${var.naming}-ecstask-securitygroup"
    Owner = var.tag_owner
  }
}

