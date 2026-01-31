variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}
variable "my_ip" {
  description = "My current public IP address for SSH access"
  type        = string
}
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}
variable "aws_profile" {
  description = "The AWS CLI profile to use"
  type        = string
}