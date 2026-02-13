output "target_group_arn" {
  description = "The ARN of the target group for ECS to register with"
  value       = aws_lb_target_group.app.arn
}

output "alb_security_group_id" {
  description = "The ID of the security group created for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "alb_dns_name" {
  description = "The public DNS name of the ALB"
  value       = aws_lb.main.dns_name
}