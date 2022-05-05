variable "region" {
  type = string
  description = "The target region for this deployment"
}
variable "ecr_repo_name" {
  type = string
  description = "ECR Repository name"
}
variable "s3bucket" {
  type = string
  description = "S3 bucket that serves WebTier"
}
variable "prefix" {
  type = string
  description = "Project or Initiate name"
}
variable "environment" {
  type = string
  description = "Environment type: QA or STG or PROD"
}
variable "naming" {
  type = string
  description = "Component naming convention: prefix-environment"
}