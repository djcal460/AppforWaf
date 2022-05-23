variable "region" {
  type = string
  description = "The target region for this deployment"
}
variable "s3bucket" {
  type = string
  description = "s3 bucket that serves web tier"
}
variable "vpc_id" {
  type =  string
  description = "VPC with private and public subnets"
}
variable "ecr_repo_name" {
  type = string
  description = "ECR repositotry name"
}
variable "ecr_image_uri" {
  type = string
  description = "Docker image to run in the ECS cluster"
}
variable "ecs_container_port" {
  type = string
  description = "Port exposed by the container"
}
variable "docker_image_port" {
  type = string
  description = "Port exposed by the docker image"
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
  description = "Resources naming convention <prefix>-<environment>"
}
variable "healthcheck" {
  type = string
  description = "Health check path"
}
variable "https_domain_name" {
  type = string
  description = "HTTPS Certificate Domain Name"
}
variable "autoscaling_min_capacity" {
  type = string
  description = "Minimum tasks to run when scaling down"
}
variable "autoscaling_max_capacity" {
  type = string
  description = "Maximum tasks to run when scaling up"
}
variable "fargate_cpu" {
  type = string
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}
variable "fargate_memory" {
  type = string
  description = "Fargate instance memory to provision (in MiB)"
}
variable "ecs_desired_tasks" {
  type = string
  description = "Desired number of ECS Tasks/Containers to run"
}
variable "routetable_main_cidr_igw" {
  type = string
  description = "CIDR for Internet Gateway in Main Route Table"
}
variable "ecs_task_execution_role" {
  type = string
  description = "ECS task execution role name"
}
variable "ecs_task_role" {
  type = string
  description = "ECS task role name"
}
variable "ecs_auto_scale_role" {
  type = string
  description = "ECS auto scale role Name"
}
variable "cidr_ipv4_all" {
  type = string
  description = "CIDR block to allow all traffic"
}
variable "protocol_all" {
  type = string
  description = "Allow all protocols"
}
variable "protocol_tcp" {
  type = string
  description = "Allow protocol type TCP"
}
variable "ports_all" {
  type = string
  description = "Allow all ports"
}
variable "port_https" {
  type = string
  description = "Allow HTTPS port only"
}
variable "tag_public" {
  description = "Public subnets"
  default = "Public"
}
variable "tag_private" {
  description = "Private subnets"
  default = "Private"
}
variable "tag_owner" {
  description = "Create owner tag for the all the resources"
  default = "XOE Digital"
}
variable "ecr_image_tag" {
  description = "ECR image tag"
  default = "latest"
}

variable "rt_non_prod" {
  description = "no route table creation for vpc for non prod webtier"
  default = 1
}