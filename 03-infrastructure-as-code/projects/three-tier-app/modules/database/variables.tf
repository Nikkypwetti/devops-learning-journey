variable "private_data_subnets" {
  description = "The private data subnets where the database is deployed"
  type        = list(string)
}

variable "db_sg_id" {
  description = "The ID of the database security group"
  type        = string
}

variable "db_password" {
  description = "The password for the database user"
  type        = string
  sensitive   = true
}