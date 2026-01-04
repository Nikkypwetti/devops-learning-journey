variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS CLI profile to use"
  type        = string
}

variable "bucket_name" {
  description = "Must be globally unique"
  type        = string
}