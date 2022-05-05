terraform {
  backend "s3" {}
}
data "terraform_remote_state" "tf_state" {
  backend = "s3"
  workspace = terraform.workspace
  config = {
    bucket  = var.s3bucket
    key     = "ecr.tfstate"
    region  = "us-east-1"
    encrypt = true
    workspace_key_prefix = "frame/web-tier/tf-state"
    profile = "default"
    dynamodb_table = "xoe-digital-tfstate-lock"
  }
}