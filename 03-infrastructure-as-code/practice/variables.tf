variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "instance_type" {
  default     = "t3.micro"
  description = "The type of EC2 instance to create"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair in AWS"
  type        = string
}

variable "private_key_path" {
  description = "The local path to the private key (.pem) file"
  type        = string
}