variable "name" {
  description = "Name for the ALB and related resources"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the ALB and Target Group will be created"
  type        = string
}

variable "subnets" {
  description = "A list of public subnet IDs for the ALB"
  type        = list(string)
}

# variable "security_groups" {
#   description = "List of security group IDs for the ALB"
#   type        = list(string)
#   default     = []
# }