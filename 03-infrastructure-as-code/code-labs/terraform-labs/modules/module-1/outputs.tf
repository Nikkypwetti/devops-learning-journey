output "public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.main.id
}

output "instance_id" {
  value = aws_instance.this.id
}


