#!/bin/bash

# Add Prometheus Helm repository
echo "Adding Prometheus Helm repository..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Update the local Helm repository
echo "Updating local Helm repository..."
helm repo update

# Install Prometheus stack
RELEASE_NAME="prometheus-stack"  # Change this name as desired
echo "Installing Prometheus stack with release name: $RELEASE_NAME"
helm install $RELEASE_NAME prometheus-community/kube-prometheus-stack

# Get Grafana admin password
echo "Retrieving Grafana admin password..."
GRAFANA_PASSWORD=$(kubectl get secret --namespace default $RELEASE_NAME-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
echo "Grafana Admin Password: $GRAFANA_PASSWORD"

# Note to user
echo "Prometheus deployment completed."


####Not Automated yet#####

#1. build ECR
# Retrieve an authentication token and authenticate your Docker client to your registry. Use the AWS CLI:
#aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 255945442255.dkr.ecr.us-east-1.amazonaws.com
#Note: If you receive an error using the AWS CLI, make sure that you have the latest version of the AWS CLI and Docker installed.

#2. Build your Docker image using the following command. For information on building a Docker file from scratch see the instructions here . You can skip this step if your image is already built:
#docker build -t junjie-flask-app .
#After the build completes, tag your image so you can push the image to this repository:
#docker tag junjie-flask-app:latest 255945442255.dkr.ecr.us-east-1.amazonaws.com/junjie-flask-app:latest

#3. Run the following command to push this image to your newly created AWS repository:
#docker push 255945442255.dkr.ecr.us-east-1.amazonaws.com/junjie-flask-app:latest