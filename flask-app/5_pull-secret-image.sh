#!/bin/bash

# Define variables
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="255945442255"
ECR_REPO_NAME="junjie-flask-app"
IMAGE_NAME="flask-app"
IMAGE_TAG="latest"

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
docker tag "$IMAGE_NAME:latest" "$REPO_URI:$IMAGE_TAG"

# Step 4: Push the Docker image to ECR
echo "Pushing Docker image to ECR..."
docker push "$REPO_URI:$IMAGE_TAG"
if [ $? -ne 0 ]; then
  echo "Failed to push Docker image to ECR. Please check the repository permissions."
  exit 1
fi

echo "Docker image successfully pushed to ECR: $REPO_URI:$IMAGE_TAG"
