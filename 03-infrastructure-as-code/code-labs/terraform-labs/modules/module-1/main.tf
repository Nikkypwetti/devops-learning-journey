terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
  }
}
# Find the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# Get your local public IP
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

# Automatically create the Key Pair in AWS
resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file("${path.root}/${var.public_key_path}")
}

# The EC2 Instance
resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.this.key_name
  monitoring    = true

  vpc_security_group_ids = [aws_security_group.main.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true # Fix: Enables encryption
    volume_type = "gp3"
  }


  tags = {
    Name = var.instance_name
  }
}

# Security Group
resource "aws_security_group" "main" {
  name_prefix = "${var.instance_name}-sg"
  description = "Managed by Terraform"

  ingress {
    description = "SSH from local IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  ingress {
    description = "HTTP from local IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "Allow all outbound traffic to the internet" # Adding this fixes the warning
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]

  }
}