#resource "aws_ecr_repository" "junjie_flask_app" {
#  name = "junjie-flask-app"
#}


provider "aws" {
  region = "us-east-1"  # Specify your desired region
}

resource "aws_ecr_repository" "junjie_flask_app" {
  #name = "sctp-sandbox/junjie-flask-app"  # Namespace with the repository name
  name = "junjie-flask-app"  # Use a simple name without slashes
  image_tag_mutability = "MUTABLE"  # Optional: Allows image tags to be overwritten
  lifecycle {
    prevent_destroy = false  # Optional: Set to true to prevent accidental deletion
  }
}

output "repository_url" {
  value = aws_ecr_repository.junjie_flask_app.repository_url
}
