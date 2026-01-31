terraform {
  required_version = ">= 1.0" # Use your current version or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # New HTTP provider to get your IP address
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = "practice"
}

data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "first_instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name
  monitoring    = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true # Fix: Enables encryption
    volume_type = "gp3"
  }

  # LINK TO YOUR NETWORK
  # trivy:ignore:AVD-AWS-0164
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  associate_public_ip_address = true # Crucial for SSH access

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }

  # Connection block tells Terraform how to communicate with the instance
  connection {
    type = "ssh"
    user = "ec2-user"
    # Use quotes and path.module to ensure the path is interpreted correctly
    private_key = var.private_key_path != "" ? file(var.private_key_path) : ""
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
      "echo '<h1>Welcome to my Terraform Project</h1>' | sudo tee /usr/share/nginx/html/index.html"
    ]
  }

  tags = {
    Name = "HelloWorld"
  }
}

# create a security group (firewall) to allow inbound traffic
resource "aws_security_group" "allow_tls" {
  name        = "allow_web_traffic"
  description = "Allow SSH and HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.practice.id

  # Allow HTTP (Port 80) from anywhere
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH (Port 22) - Optional, for later
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  # Allow all outbound traffic (so the server can download updates)
  egress {
    description = "Allow all outbound traffic to the internet" # Adding this fixes the warning
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }
  tags = {
    Name = "allow_web_traffic_sg"
  }
}

# create custom VPC
resource "aws_vpc" "practice" {
  cidr_block = "10.0.0.0/16" # This gives you 65,536 IP addresses

  tags = {
    Name = "practice-VPC"
  }
}

# create public subnet
# trivy:ignore:AVD-AWS-0164
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.practice.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "practice-public-subnet"
  }
}

# create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.practice.id

  tags = {
    Name = "practice-igw"
  }
}

# create route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.practice.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "practice-public-rt"
  }
}
# associate route table with public subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


