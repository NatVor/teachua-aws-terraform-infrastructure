variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.64.0/19", "10.0.96.0/19"]
}

variable "availability_zones" {
  description = "List of availability zones to use."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  description = "Tags for the resources."
  type        = map(string)
  default = {
    Name = "main"
  }
}

# variable "db_password" {
#  description = "Password for the RDS database"
#  type        = string
#}

