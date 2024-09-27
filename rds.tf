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

resource "aws_db_subnet_group" "teachua" {
  name       = "teachua-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_us_east_1a.id,
    aws_subnet.private_us_east_1b.id
  ]

  tags = {
    Name = "teachua-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds_security_group"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    # security_groups = [aws_security_group.eks_nodes.id] # Доступ лише для нодів EKS
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "rds_security_group"
  }
}

resource "aws_iam_role" "rds_access_role" {
  name = "rds-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "rds.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"  
  role       = aws_iam_role.rds_access_role.name
}

data "aws_secretsmanager_secret" "db_password" {
  name = "teachua-rds-cred"
}

data "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id = data.aws_secretsmanager_secret.db_password.id
}

resource "aws_db_instance" "teachua" {
  identifier             = "teachua"
  instance_class         = "db.t3.micro" 
  allocated_storage      = 8  
  engine                 = "mysql"
  engine_version         = "8.0"  
  username               = "user"
  password               = jsondecode(data.aws_secretsmanager_secret_version.db_password_version.secret_string)["password"]  
  db_name                = "teachua"  
  db_subnet_group_name   = aws_db_subnet_group.teachua.name
  vpc_security_group_ids = [aws_security_group.rds.id]  
  parameter_group_name   = aws_db_parameter_group.teachua.name
  publicly_accessible    = false  
  skip_final_snapshot    = true  
}
