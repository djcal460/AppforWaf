resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.webtier.name}/${aws_ecs_service.webtier.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.autoscaling_min_capacity
  max_capacity       = var.autoscaling_max_capacity
}
resource "aws_appautoscaling_policy" "up" {
  name               = "${var.naming}-scaleup"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.webtier.name}/${aws_ecs_service.webtier.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
  depends_on = [aws_appautoscaling_target.target]
}
resource "aws_appautoscaling_policy" "down" {
  name               = "${var.naming}-scaledown"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.webtier.name}/${aws_ecs_service.webtier.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
  depends_on = [aws_appautoscaling_target.target]
}
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.naming}-cpuhighutilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    ClusterName = aws_ecs_cluster.webtier.name
    ServiceName = aws_ecs_service.webtier.name
  }
  alarm_actions = [aws_appautoscaling_policy.up.arn]
}
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "${var.naming}-cpulowutilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"
  dimensions = {
    ClusterName = aws_ecs_cluster.webtier.name
    ServiceName = aws_ecs_service.webtier.name
  }
  alarm_actions = [aws_appautoscaling_policy.down.arn]
}

