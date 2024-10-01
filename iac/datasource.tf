data "aws_eks_cluster" "cluster" {
  name = "cluster-tech-challenge"
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}