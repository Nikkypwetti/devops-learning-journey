variable "github_repo" {
  description = "The GitHub repository allowed to assume the role"
  type        = string
  default     = "Nikkypwetti/devops-learning-journey"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for deployment"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS Account ID"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS CLI profile to use"
  type        = string
}