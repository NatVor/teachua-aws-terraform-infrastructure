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

  # Single subnet to avoid data transfer charges while testing.
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

data "tls_certificate" "eks" {
  url = aws_eks_cluster.teachua.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.teachua.identity[0].oidc[0].issuer
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.teachua.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.teachua.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.teachua.id]
      command     = "aws"
    }
  }
}

resource "helm_release" "ingress_nginx" {
  name = "staging"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.4.0"

  set {
    name  = "controller.ingressClassResource.name"
    value = "external-ingress-nginx"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
}

terraform {
  backend "s3" {
    bucket = "teachua-bucket-new"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
