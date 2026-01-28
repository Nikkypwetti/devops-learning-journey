terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
   backend "s3" {
    bucket         = "nikky-techies-devops-portfolio"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1" # The region where your S3 bucket is located
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}
provider "aws" {
  region  = "us-east-1" # The region you used for your S3 bucket
  profile = "learning"
}
# Optional: If you have multiple AWS profiles, specify the one you want to use