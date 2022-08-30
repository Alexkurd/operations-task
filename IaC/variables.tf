variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable "input_bucket" {
  description = "Input data bucket"

  type    = string
  default = "xeneta-s3-DEV-in"
}

variable "env" {
  default = "DEV"
}