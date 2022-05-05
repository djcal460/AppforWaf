# route 53 hosted zone id

variable "hosted_zone_name" {
  type = string
}

variable "s3bucket" {
  type = string
  description = "s3 bucket that serves web tier"
}

variable "region" {
  type = string
  description = "The target region for this deployment"
}

variable "shared_credentials_file" {
  type = string
  default = "~/.aws/credentials"
}

variable "profile" {
  type = string
  default = "default"
}

variable "rt53_alias" {
  type = string
  default = ""
}

variable "alb_name" {
  type = string
  default = ""
}