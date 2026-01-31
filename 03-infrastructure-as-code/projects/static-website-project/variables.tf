variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "aws_profile" {
  description = "The AWS CLI profile to use"
  type        = string
}

variable "bucket_name" {
  description = "Must be globally unique"
  type        = string
}