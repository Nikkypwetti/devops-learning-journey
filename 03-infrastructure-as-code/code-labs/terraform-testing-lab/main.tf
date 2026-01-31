terraform {
  required_version = ">= 1.0" # Use your current version or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }
}

provider "aws" {
  region = "us-east-1"
}

# Find the latest Ubuntu 22.04 AMI
# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["099720109477"] # Canonical's AWS Account ID

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# resource "aws_security_group" "allow_web" {
#   name        = "allow_web_traffic"
#   description = "Allow inbound web traffic"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_instance" "web_server" {
#   ami           = data.aws_ami.ubuntu.id # Uses the ID found by the data source
#   instance_type = "t3.micro"
#  metadata_options {
#     http_endpoint = "enabled"
#     http_tokens   = "required"
#   }

#   root_block_device {
#     encrypted   = true # Fix: Enables encryption
#     volume_type = "gp3"
#   }
#   vpc_security_group_ids = [aws_security_group.allow_web.id]

#   tags = {
#     Name        = "TestServer"
#     Environment = "Dev"
#   }
# }


variable "os_type" {
  description = "Which OS to deploy: 'ubuntu' or 'amazon-linux'"
  type        = string
  default     = "ubuntu"
}

# 1. Define Search Filters in a Local Map
locals {
  os_filters = {
    ubuntu = {
      name  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      owner = "099720109477" # Canonical
    }
    amazon-linux = {
      name  = "al2023-ami-2023.*-x86_64"
      owner = "137112412989" # Amazon
    }
  }
}

# 2. Dynamic Data Source lookup
data "aws_ami" "selected" {
  most_recent = true
  owners      = [local.os_filters[var.os_type].owner]

  filter {
    name   = "name"
    values = [local.os_filters[var.os_type].name]
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow inbound web traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.selected.id
  instance_type = "t3.micro"
  monitoring    = true

  vpc_security_group_ids = [aws_security_group.allow_web.id]
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true # Fix: Enables encryption
    volume_type = "gp3"
  }


  tags = {
    Name = "TestServer-${var.os_type}"
  }
}

output "instance_arn" {
  value = aws_instance.web_server.arn
}