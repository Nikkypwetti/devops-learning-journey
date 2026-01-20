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

  # Allow the instance to talk to the internet (to download updates)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = var.ami_id # Your Golden AMI ID
  instance_type = "t3.micro"

  # Attach the IAM Instance Profile
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Golden-AMI-Test-Instance"
  }
}

output "website_url" {
  value = "http://${aws_instance.web_server.public_ip}"
}