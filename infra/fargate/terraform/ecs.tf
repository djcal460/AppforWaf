resource "aws_ecs_cluster" "webtier" {
  name = "${var.naming}-cluster"
  tags          = {
    Name  = "${var.naming}-cluster"
    Owner = var.tag_owner
  }
}
data "aws_ecr_image" "xoedigitalwebtier" {
  repository_name = var.ecr_repo_name
  image_tag = var.ecr_image_tag
}
data "template_file" "webtier" {
  template = file("./templates/ecs/webtier.json.tpl")
  vars = {
    container_name     = "${var.naming}-container"
    ecr_image_uri      = var.ecr_image_uri
    ecs_container_port = var.ecs_container_port
    docker_image_port  = var.docker_image_port
    fargate_cpu        = var.fargate_cpu
    fargate_memory     = var.fargate_memory
    aws_region         = var.region
    ecr_image_digest   = data.aws_ecr_image.xoedigitalwebtier.image_digest 
    awslogs_group      = "/ecs/${var.naming}"
  }
}
resource "aws_ecs_task_definition" "web-tier" {
  family                   = "${var.naming}-task"
  task_role_arn            = data.aws_iam_role.AWSTaskRoleForECS.arn
  execution_role_arn       = data.aws_iam_role.AWSServiceRoleForECS.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.webtier.rendered
  tags          = {
    Name  = "${var.naming}-task" 
    Owner = var.tag_owner
  }
}
resource "aws_ecs_service" "webtier" {
  name            = "${var.naming}-service"
  cluster         = aws_ecs_cluster.webtier.id
  task_definition = aws_ecs_task_definition.web-tier.arn
  desired_count   = var.ecs_desired_tasks
  launch_type     = "FARGATE"
  network_configuration {
    security_groups  = [aws_security_group.sg_ecs_tasks.id]
    subnets          = data.aws_subnets.public.ids
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.targetgroup.id
    container_name   = "${var.naming}-container"
    container_port   = var.ecs_container_port
  }
  depends_on = [aws_alb_listener.listener]
}

