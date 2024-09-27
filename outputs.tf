output "eks_cluster_endpoint" {
  value = aws_eks_cluster.teachua.endpoint
}

output "rds_instance_endpoint" {
  value = aws_db_instance.teachua.endpoint
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.teachua.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.teachua.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.teachua.username
  sensitive   = true
}
