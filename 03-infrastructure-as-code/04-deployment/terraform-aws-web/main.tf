terraform {
  required_version = ">= 1.0" # Use your current version or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # Newly added HTTP provider to fetch public IP
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
  }
}
provider "aws" {
  region  = "us-east-1" # Make sure this matches your Packer region
  profile = "learning"
}

data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

# Define a Security Group to allow Web Traffic
resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"] # In production, use your own IP here!
  }

  egress {
    description = "Allow all outbound traffic to the internet" # Adding this fixes the warning
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }
}

# Launch the EC2 Instance using your Golden AMI
resource "aws_instance" "web_server" {
  ami           = "ami-07eefb25c0129be09" # PASTE YOUR NEW AMI ID HERE
  instance_type = "t3.micro"
  monitoring    = true

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true # Fix: Enables encryption
    volume_type = "gp3"
  }
  tags = {
    Name = "Deployed-With-Terraform"
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}