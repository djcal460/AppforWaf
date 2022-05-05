resource "aws_ecr_repository" "container" {
    name = var.ecr_repo_name
}
output "Registry_URL" {
    value ="${aws_ecr_repository.container.repository_url}"
}