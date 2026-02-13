variable "docker_hub_username" {
  description = "docker username for pulling the image from Docker Hub"
  type        = string
  default     = "nikkytechies" # Put your real username here
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_theme" {
  type        = string
  description = "Dashboard theme: 'dark' or 'light'"
  default     = "dark"
}