terraform {
  backend "s3" {
    bucket = "sctp-ce7-tfstate"
    key    = "junjie-capstone-wip-terraform.tfstate"
    region = "us-east-1"
  }
}