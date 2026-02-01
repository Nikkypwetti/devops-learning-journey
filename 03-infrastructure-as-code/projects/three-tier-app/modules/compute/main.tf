terraform {
  required_version = ">= 1.0" # Use your current version or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 1. Fetch the latest AMI dynamically
data "aws_ami" "packer_image" {
  most_recent = true
  owners      = ["self"] # Ensures you only use your own images

  filter {
    name = "name"
    # This must match the 'ami_name' you set in your Packer .pkr.hcl file
    values = ["golden-nginx-v1-*"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

# 2. Use the ID from the data source
resource "aws_launch_template" "app" {
  name_prefix   = "app-template-"
  image_id      = data.aws_ami.packer_image.id
  instance_type = "t3.micro"

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.app_sg_id]
  }
}

resource "aws_autoscaling_group" "app" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  target_group_arns   = [var.target_group_arn]
  vpc_zone_identifier = var.private_app_subnets

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}