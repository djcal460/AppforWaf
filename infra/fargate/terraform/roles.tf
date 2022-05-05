# ECS task execution role data
data "aws_iam_role" "AWSServiceRoleForECS"{
  name = var.ecs_task_execution_role
}
# ECS auto scaling role data
data "aws_iam_role" "AWSServiceRoleForAutoScaling"{
  name = var.ecs_auto_scale_role
}
# ECS task role data
data "aws_iam_role" "AWSTaskRoleForECS"{
  name = var.ecs_task_role
}