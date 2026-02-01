variable "vpc_id" {
  description = "The ID of the VPC where the ALB is deployed"
  type        = string
}

variable "public_subnets" {
  description = "The public subnets where the ALB is deployed"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "The ID of the ALB security group"
  type        = string
}