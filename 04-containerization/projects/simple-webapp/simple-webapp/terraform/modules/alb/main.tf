
# LOAD BALANCER (ALB) AND TARGET GROUP
resource "aws_lb" "main" {
  name                       = var.name
  internal                   = false # trivy:ignore:AVD-AWS-0053
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = var.subnets
  drop_invalid_header_fields = true
}

resource "aws_lb_target_group" "app" {
  name        = "webapp-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path = "/health"
  }
}

# trivy:ignore:AVD-AWS-0054
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}


# SECURITY GROUP 
resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name} load balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ALB to talk to the Container on 3000
  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    self      = true # This allows any resource with THIS security group to talk to each other
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # trivy:ignore:AVD-AWS-0104
  }
}