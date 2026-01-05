module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "vi13-vpc"
  cidr = "10.0.0.0/16"

  # Availability Zones
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # NAT Gateway - One per AZ for high availability
  enable_nat_gateway = true
  single_nat_gateway = true # Set to true to save costs during practice

  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "VI13"
  }
}