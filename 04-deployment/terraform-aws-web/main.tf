terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Make sure this matches your Packer region
  profile = "learning"
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
    cidr_blocks = ["0.0.0.0/0"] # In production, use your own IP here!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch the EC2 Instance using your Golden AMI
resource "aws_instance" "web_server" {
  ami                    = "ami-07eefb25c0129be09" # PASTE YOUR NEW AMI ID HERE
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Deployed-With-Terraform"
  }
}

output "public_ip" {
  value = aws_instance.web_server.public_ip
}