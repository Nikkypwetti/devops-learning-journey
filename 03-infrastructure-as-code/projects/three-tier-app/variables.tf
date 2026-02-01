variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "github_repo" {
  description = "The GitHub repository allowed to assume the role"
  type        = string
  default     = "Nikkypwetti/devops-learning-journey"
}

variable "db_password" {
  description = "RDS root password"
  type        = string
  sensitive   = true
}
