variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "profile" {
  description = "The AWS CLI profile to use"
  type        = string
}

variable "key_name" {
  description = "The name of the SSH key pair in AWS"
  type        = string
}

variable "instance_name" {
  description = "The name tag for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
}

variable "public_key_path" {
  description = "The local path to the public key (.pub) file"
  type        = string
}