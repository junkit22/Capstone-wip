# Referenced from https://terrateam.io/blog/terraform-types/
variable "vpc_config" {
  description = "vpc config"
  type = object({
    vpc_name    = string,
    azs         = list(string),
    pri_subnets = list(string),
    pub_subnets = list(string)
  })

  default = {
    "vpc_name"    = "ce7-junjie-vpc"
    "azs"         = ["us-east-1a", "us-east-1b"],
    "pri_subnets" = ["10.0.2.0/24", "10.0.3.0/24"],
    "pub_subnets" = ["10.0.0.0/24", "10.0.1.0/24"]
  }
}

variable "def_tags" {
  description = "default tags"
  type = object({
    creator     = string,
    environment = string
  })
  default = {
    "creator"     = "ce7-junjie",
    "environment" = "dev"
  }
}

variable "s3_vpce" {
  description = "name of vpce for S3"
  type        = string
  default     = "junjie-tf-vpce-s3"
}

variable "sg_name" {
  description = "Name of Terraform EC2 security group"
  type        = string
  default     = "ce7-junjie-sg"
}

variable "eks_clusr_conf" {
  description = "eks cluster configurations"
  type = object({
    cluster_name       = string,
    node_group_name    = string,
    node_scale_desired = number,
    node_scale_max     = number,
    node_scale_min     = number,
    max_unavail        = number
  })

  default = {
    "cluster_name"       = "ce7-junjie-eks",
    "node_group_name"    = "ce7-junjie-eks-nodes",
    "node_scale_desired" = 2,
    "node_scale_max"     = 3,
    "node_scale_min"     = 1,
    "max_unavail"        = 1
  }
}

variable "key_name" {
  description = "Name of EC2 Key Pair"
  type        = string
  default     = "ce7-junjie-useast1-05112024" # Change accordingly
}

# These are variables used in the iam.tf file.
# The name of the variables are the block names assigned. 
variable "iam_conf" {
  description = "iam configurations requirements"
  type = object({
    eks_role               = string,
    ce7-junjie-nodes           = string,
    eks_cluster_autoscaler = string
  })

  default = {
    "eks_role"               = "ce7-junjie-eks-role",
    "ce7-junjie-nodes"       = "ce7-junjie-eks-node-group-nodes",
    "eks_cluster_autoscaler" = "ce7-junjie-eks-cluster-autoscaler"
  }
}