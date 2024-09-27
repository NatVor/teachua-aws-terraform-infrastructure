output "eks_cluster_endpoint" {
  value = aws_eks_cluster.teachua.endpoint
}

output "rds_instance_endpoint" {
  value = aws_db_instance.teachua.endpoint
}
