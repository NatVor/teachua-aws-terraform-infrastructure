provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "TeachUA"
 }
}

# resource "aws_internet_gateway" "main" {
#  vpc_id = aws_vpc.main.id

#  tags = {
#    Name = "Main Internet Gateway"
#  }
#}

# resource "aws_route_table" "public" {
#}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr

  availability_zone = data.aws_availability_zones.available.names[0]  

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.main.id
 cidr_block        = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

resource "aws_db_subnet_group" "teachua" {
  name       = "teachua"
  subnet_ids = aws_subnet.private_subnets[*].id 

  tags = {
    Name = "TeachUA"
  }
}

resource "aws_security_group" "rds" {
  name   = "teachua_rds"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "teachua_rds"
  }
}

resource "aws_db_parameter_group" "teachua" {
  name   = "teachua"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "collation_server"
    value = "utf8_bin"
  }
}

resource "aws_db_instance" "teachua" {
  identifier             = "teachua"
  instance_class         = "db.t3.micro"
  allocated_storage      = 8
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = "teachua_user"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.teachua.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.teachua.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}
