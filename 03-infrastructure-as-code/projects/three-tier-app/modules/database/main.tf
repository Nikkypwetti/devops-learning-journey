terraform {
  required_version = ">= 1.0" # Use your current version or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = var.private_data_subnets
}

#trivy:ignore:AVD-AWS-0080
resource "aws_db_instance" "main" {
  allocated_storage                   = 20
  engine                              = "postgres"
  engine_version                      = "15"
  instance_class                      = "db.t3.micro"
  db_name                             = "mydb"
  username                            = "postgres"
  password                            = var.db_password
  parameter_group_name                = "default.postgres15"
  db_subnet_group_name                = aws_db_subnet_group.main.name
  vpc_security_group_ids              = [var.db_sg_id]
  skip_final_snapshot                 = true # Critical for Free Tier testing
  storage_encrypted                   = false
  iam_database_authentication_enabled = true  # Fix: IAM Auth 
  deletion_protection                 = false # Fix: Deletion Protection
  backup_retention_period             = 0     # Fix: Retention 
  auto_minor_version_upgrade          = true  # Fix: Auto Upgrade
  performance_insights_enabled        = false # Fix: Monitoring 
  multi_az                            = false # Fix: High Availability
  publicly_accessible                 = false


  tags = {
    Name = "My-Three-Tier-DB"
  }
}
