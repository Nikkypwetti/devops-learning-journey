# This prints the raw Public IP address
output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.first_instance.public_ip
}

# This creates a clickable link for your Nginx server
output "website_url" {
  description = "The URL to access the Nginx web server"
  value       = "http://${aws_instance.first_instance.public_ip}"
}