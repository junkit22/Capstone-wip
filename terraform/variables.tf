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