resource "aws_eks_cluster" "teachua" {
  name     = var.eks_cluster_name
  version  = var.eks_version
  role_arn = aws_iam_role.teachua.arn

  vpc_config {
    subnet_ids = concat(var.private_subnet_ids, var.public_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [aws_iam_role_policy_attachment.teachua_amazon_eks_cluster_policy]
}

resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.teachua.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [
    aws_subnet.private_us_east_1a.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3a.xlarge"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.nodes_amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.nodes_amazon_ec2_container_registry_read_only,
  ]
}

terraform {
  backend "s3" {
    bucket = "teachua-bucket-new"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
