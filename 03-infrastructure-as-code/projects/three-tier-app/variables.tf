variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy resources in"
  type        = string
}


variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}

variable "aws_s3_bucket" {
  description = "The name of the AWS S3 bucket for the three-tier application"
  type        = string
}