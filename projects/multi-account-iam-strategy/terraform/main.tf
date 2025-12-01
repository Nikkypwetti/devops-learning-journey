terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "techcorp-terraform-state"
    key    = "iam-strategy/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "management"
  assume_role {
    role_arn = "arn:aws:iam::111111111111:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "production"
  assume_role {
    role_arn = "arn:aws:iam::222222222222:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "development"
  assume_role {
    role_arn = "arn:aws:iam::333333333333:role/OrganizationAccountAccessRole"
  }
}