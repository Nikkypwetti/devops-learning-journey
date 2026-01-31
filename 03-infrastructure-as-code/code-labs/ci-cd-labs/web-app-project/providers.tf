terraform {
  required_version = ">= 1.0" # Use your current version or higher
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket       = "nikky-techies-devops-portfolio"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1" # The region where your S3 bucket is located
    use_lockfile = true
    encrypt      = true
  }
}
provider "aws" {
  region  = var.aws_region # The region you used for your S3 bucket
  profile = var.aws_profile
}
# Optional: If you have multiple AWS profiles, specify the one you want to use

