variable "account_a_id" {
  description = "Account A (Source) ID"
  type        = string
}

variable "account_b_id" {
  description = "Account B (Target) ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}