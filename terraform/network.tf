# VPC Module Creation
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = var.vpc_config["vpc_name"]
  cidr = "10.0.0.0/16"

  azs             = var.vpc_config["azs"]
  private_subnets = var.vpc_config["pri_subnets"]
  public_subnets  = var.vpc_config["pub_subnets"]

  enable_nat_gateway      = false
  enable_vpn_gateway      = false
  map_public_ip_on_launch = true

  tags = var.def_tags
}

# S3 VPC Endpoint - allow private access to S3 from the VPC without using the public internet.
resource "aws_vpc_endpoint" "s3-vpce" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = var.s3_vpce
  }
}

# VPC Security Group
resource "aws_security_group" "junjie-sg" {
  name        = var.sg_name
  description = var.sg_name
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = var.sg_name
  }

  ingress {
    from_port   = 80            # Allow inbound traffic on TCP port 80 (HTTP)
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443           # Allow inbound traffic on TCP port 443 (HTTPS)
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22            # Allow inbound traffic on TCP port 22 (SSH)
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000          # Allow inbound traffic on TCP port 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000          # Allow inbound traffic on TCP port 30000
    to_port     = 30000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 31000          # Allow inbound traffic on TCP port 31000
    to_port     = 31000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0             # Allow all outbound traffic
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"          # semantically equivalent to all ports
  }
}
