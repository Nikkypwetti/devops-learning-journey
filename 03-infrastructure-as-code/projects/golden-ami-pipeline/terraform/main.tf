# 1. Create the IAM Role for EC2
resource "aws_iam_role" "ec2_monitoring_role" {
  name = "EC2MonitoringAndSecurityRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

# 2. Attach the CloudWatch Policy (For RAM/Disk metrics)
resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.ec2_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# 3. Attach the SSM Managed Policy (For Inspector & Session Manager)
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# 4. Create the Instance Profile (The "Badge" for the EC2)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2MonitoringProfile"
  role = aws_iam_role.ec2_monitoring_role.name
}

# This creates the "Security Group" (Firewall)
resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow HTTP and SSH inbound traffic"

  # Port 80 for Nginx
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Port 22 for SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Allow the instance to talk to the internet (to download updates)
  egress {
    description = "Allow all outbound traffic to the internet" # Adding this fixes the warning
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }
}

# Launch an EC2 Instance using the Golden AMI
data "aws_ami" "golden_nginx" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["golden-nginx-v1-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.golden_nginx.id
  instance_type = var.instance_type
  # Attach the IAM Instance Profile
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  monitoring             = true
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
    Name = "Golden-AMI-Test-Instance"
  }
}

output "website_url" {
  value = "http://${aws_instance.web_server.public_ip}"
}