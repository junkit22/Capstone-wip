#!/bin/bash

# Prompt for AWS region and repository details
read -p "Enter the AWS region (e.g., us-east-1): " AWS_REGION
read -p "Enter the AWS account ID: " AWS_ACCOUNT_ID
read -p "Enter the ECR repository name: " ECR_REPO_NAME
read -p "Enter the Docker image name (default: flask-app): " IMAGE_NAME
IMAGE_NAME=${IMAGE_NAME:-flask-app}

# Construct the full repository URI
REPO_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"

# Step 1: Log in to AWS ECR
echo "Logging in to ECR..."
aws ecr get-login-password --region "$AWS_REGION" | docker login --username AWS --password-stdin "$REPO_URI"
if [ $? -ne 0 ]; then
  echo "Failed to log in to ECR. Please check your AWS credentials and permissions."
  exit 1
fi

# Step 2: Build the Docker image
echo "Building Docker image..."
docker build -t "$IMAGE_NAME" .
if [ $? -ne 0 ]; then
  echo "Docker build failed. Please check your Dockerfile and try again."
  exit 1
fi

# Step 3: Tag the Docker image
echo "Tagging Docker image..."
docker tag "$IMAGE_NAME:latest" "$REPO_URI:latest"

# Step 4: Push the Docker image to ECR
echo "Pushing Docker image to ECR..."
docker push "$REPO_URI:latest"
if [ $? -ne 0 ]; then
  echo "Failed to push Docker image to ECR. Please check the repository permissions."
  exit 1
fi

echo "Docker image successfully pushed to ECR: $REPO_URI:latest"