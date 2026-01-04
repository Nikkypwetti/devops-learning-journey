terraform {
#   backend "s3" {
#     bucket         = "nikky-techies-terraform-state-bucket-21"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     use_lockfile   = true
#     profile        = "practice"
#  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

}
