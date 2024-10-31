# Defines an EKS cluster resource named ce7-junjie
resource "aws_eks_cluster" "ce7-junjie" {
  name     = var.eks_clusr_conf["cluster_name"]
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

  depends_on = [aws_iam_role_policy_attachment.ce7-junjie-EKSClusterPolicy]
}

# Defines an EKS node group resource named ce7-junjie-nodes
resource "aws_eks_node_group" "ce7-junjie-nodes" {
  cluster_name    = aws_eks_cluster.ce7-junjie.name
  node_group_name = var.eks_clusr_conf["node_group_name"]
  node_role_arn   = aws_iam_role.ce7-junjie-nodes.arn

  subnet_ids = module.vpc.public_subnets

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  remote_access {
    ec2_ssh_key = var.key_name
    
  }

  scaling_config {
    desired_size = var.eks_clusr_conf["node_scale_desired"]
    max_size     = var.eks_clusr_conf["node_scale_max"]
    min_size     = var.eks_clusr_conf["node_scale_min"]
  }

  update_config {
    max_unavailable = var.eks_clusr_conf["max_unavail"]
  }

  labels = var.def_tags
  
  depends_on = [    # ensures that the necessary IAM role policy attachments are created before the node group is established
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}
