# Creates an IAM role for the EKS cluster named eks_role
resource "aws_iam_role" "eks_role" {
  name = var.iam_conf["eks_role"]
  tags = var.def_tags

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

# Attaches the AmazonEKSClusterPolicy to the eks_role
resource "aws_iam_role_policy_attachment" "ce7-junjie-EKSClusterPolicy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#  Creates an IAM role for the EKS worker nodes named ce7-junjie-nodes
resource "aws_iam_role" "ce7-junjie-nodes" {
  name = var.iam_conf["ce7-junjie-nodes"]

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# These resources attach several policies to the ce7-junjie-nodes role
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ce7-junjie-nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ce7-junjie-nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ce7-junjie-nodes.name
}

# Set up IAM OIDC Provider for EKS
data "tls_certificate" "eks" {
  url = aws_eks_cluster.ce7-junjie.identity[0].oidc[0].issuer   # TLS Certificate Data Source: Retrieves the OIDC issuer URL's TLS certificate to verify it.
}

resource "aws_iam_openid_connect_provider" "eks" {              #IAM OIDC Provider Resource: Creates an IAM OIDC provider, enabling Kubernetes service accounts to assume IAM roles.
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.ce7-junjie.identity[0].oidc[0].issuer
}

# Configures IAM Role for Cluster Autoscaler
data "aws_iam_policy_document" "eks_cluster_autoscaler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:ce7-junjie-kube:cluster-autoscaler"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_cluster_autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_autoscaler_assume_role_policy.json
  name               = var.iam_conf["eks_cluster_autoscaler"]
}

# Configures IAM Policy for Cluster Autoscaler
resource "aws_iam_policy" "eks_cluster_autoscaler" {    # Defines an IAM policy that grants permissions needed for the cluster autoscaler to manage EC2 auto-scaling groups.
  name = "ce7-junjie-eks-cluster-autoscaler"

  policy = jsonencode({
    Statement = [{
      Action = [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

# Outputs the ARN (Amazon Resource Name) of the eks_cluster_autoscaler role, allowing easy reference to this resource after the Terraform configuration is applied.
output "eks_cluster_autoscaler_arn" {
  value = aws_iam_role.eks_cluster_autoscaler.arn
}

