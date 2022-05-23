resource "aws_cloudwatch_log_group" "webtier_log_group" {
  name              = "/ecs/${var.naming}"
  retention_in_days = 30
}
resource "aws_cloudwatch_log_stream" "webtier_log_stream" {
  name           = "${var.naming}-logstream"
  log_group_name = aws_cloudwatch_log_group.webtier_log_group.name
}

