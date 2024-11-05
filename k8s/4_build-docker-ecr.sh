#!/bin/bash

# Variables
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="255945442255"
ECR_REPOSITORY="junjie-flask-app"
IMAGE_TAG="latest"

# Step 1: Check AWS CLI version
echo "Checking AWS CLI version..."
aws --version || { echo "AWS CLI not installed. Please install the latest AWS CLI version."; exit 1; }

# Step 2: Check Docker version
echo "Checking Docker version..."
docker --version || { echo "Docker not installed. Please install the latest Docker version."; exit 1; }

# Step 3: Log in to ECR
echo "Authenticating Docker to ECR..."
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
if [ $? -ne 0 ]; then
    echo "Docker login failed. Ensure that AWS CLI and Docker are correctly configured."
    exit 1
fi

# Step 4: Build the Docker image
echo "Building Docker image..."
docker build -t ${ECR_REPOSITORY} -f ../flask-app/Dockerfile ../flask-app
if [ $? -ne 0 ]; then
    echo "Docker build failed. Check your Dockerfile and try again."
    exit 1
fi

# Step 5: Tag the Docker image
echo "Tagging Docker image for ECR..."
docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}

# Step 6: Push the image to ECR
echo "Pushing image to ECR..."
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}
if [ $? -eq 0 ]; then
    echo "Image successfully pushed to ECR!"
else
    echo "Failed to push the image to ECR. Please check your permissions and repository settings."
    exit 1
fi
