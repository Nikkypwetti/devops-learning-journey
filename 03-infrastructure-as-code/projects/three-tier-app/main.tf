# 1. Create the OIDC Identity Provider
# resource "aws_iam_openid_connect_provider" "github" {
#   url            = "https://token.actions.githubusercontent.com"
#   client_id_list = ["sts.amazonaws.com"]
#   # AWS now handles thumbprints automatically in the background
#   thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
# }

# # 2. Define the IAM Role for GitHub Actions
# resource "aws_iam_role" "github_actions_role" {
#   name = "GitHubAction-Terraform-Managed-Role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Principal = {
#           Federated = aws_iam_openid_connect_provider.github.arn
#         }
#         Condition = {
#           StringLike = {
#             "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
#           }
#         }
#       }
#     ]
#   })
# }

# data "http" "my_ip" {
#   url = "https://ifconfig.me/ip"
# }

# --- NETWORKING ---
module "vpc" { source = "./modules/vpc" }

# --- SECURITY GROUP SHELLS (No Rules Inside) ---
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Public HTTP"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Internal App"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Private Database"
  vpc_id      = module.vpc.vpc_id
}

# --- THE BRIDGES (Connecting the Tiers) ---

# Public -> ALB
resource "aws_security_group_rule" "alb_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

# Egress for ALB
#trivy:ignore:AVD-AWS-0104
resource "aws_security_group_rule" "alb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

# ALB <-> APP
resource "aws_security_group_rule" "app_ingress_from_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.app_sg.id
}

# Egress for App
#trivy:ignore:AVD-AWS-0104
resource "aws_security_group_rule" "app_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}

# APP <-> DB
resource "aws_security_group_rule" "db_ingress_from_app" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_sg.id
  security_group_id        = aws_security_group.db_sg.id
}



# --- MODULES ---
module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = aws_security_group.alb_sg.id
}

module "compute" {
  source              = "./modules/compute"
  private_app_subnets = module.vpc.private_app_subnets
  app_sg_id           = aws_security_group.app_sg.id
  target_group_arn    = module.alb.target_group_arn
}

module "database" {
  source               = "./modules/database"
  private_data_subnets = module.vpc.private_data_subnets
  db_sg_id             = aws_security_group.db_sg.id
  db_password          = var.db_password
}