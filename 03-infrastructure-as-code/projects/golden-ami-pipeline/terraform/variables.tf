variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}
variable "my_ip" {
  description = "My current public IP address for SSH access"
  type        = string
}