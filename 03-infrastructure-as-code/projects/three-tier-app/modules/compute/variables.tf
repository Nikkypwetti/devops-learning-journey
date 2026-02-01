variable "private_app_subnets" {
  description = "The private application subnets"
  type        = list(string)
}

variable "app_sg_id" {
  description = "The ID of the application security group"
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the ALB target group"
  type        = string
}

