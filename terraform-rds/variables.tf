variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}

variable "public_subnet_cidr" {
 description = "Public Subnet CIDR values"
 default     = "10.0.1.0/24"
}
 
variable "private_subnet_cidrs" {
 # type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-1a", "us-east-1b"]
}
