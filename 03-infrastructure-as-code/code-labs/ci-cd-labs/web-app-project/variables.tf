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