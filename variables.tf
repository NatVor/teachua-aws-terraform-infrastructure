variable "region" {
  default = "us-east-1"
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
}

# variable "db_name" {
#  description = "Name of the RDS database"
#  type        = string
# }
