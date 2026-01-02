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

  vpc_security_group_ids = [aws_security_group.main.id]

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
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}