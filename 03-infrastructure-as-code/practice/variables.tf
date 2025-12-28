variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair in AWS"
  type        = string
}

variable "private_key_path" {
  description = "The local path to the private key (.pem) file"
  type        = string
}