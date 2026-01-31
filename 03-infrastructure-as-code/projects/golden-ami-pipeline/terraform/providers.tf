terraform {
  required_version = ">= 1.0" # Use your current version or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # New HTTP provider to get your IP address
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region # Or your preferred region
  profile = var.aws_profile
}