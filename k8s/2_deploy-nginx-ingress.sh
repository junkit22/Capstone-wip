#!/bin/bash

# Set the name of your EKS cluster and region
EKS_CLUSTER_NAME="ce7-junjie-eks"
REGION="us-east-1"

# Update kubeconfig for the EKS cluster
echo "Updating kubeconfig for the EKS cluster..."
aws eks update-kubeconfig --name $EKS_CLUSTER_NAME --region $REGION

# Add the NGINX Ingress Helm repository
echo "Adding NGINX Ingress Helm repository..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Update the local Helm repository
echo "Updating local Helm repository..."
helm repo update

# Install the NGINX Ingress Controller
RELEASE_NAME="nginx-ingress"  # Change this name as desired
echo "Installing NGINX Ingress Controller with release name: $RELEASE_NAME"
helm install $RELEASE_NAME ingress-nginx/ingress-nginx

# Check the status of services
echo "Checking for Ingress Controller services..."
kubectl get svc

# Check the status of pods
echo "Checking for Ingress Controller pods..."
kubectl get pods

# Apply your ingress configuration (assuming ingress.yaml is in the current directory)
echo "Applying ingress configuration from ingress.yaml..."
kubectl apply -f ingress.yaml

# Apply Flask app configuration (assuming flask-app.yaml is in the current directory)
echo "Applying Flask app configuration from flask-app.yaml..."
kubectl apply -f flask-app.yaml

# Check ingress resources
echo "Checking ingress resources..."
kubectl get ingress

# Note to user
echo "Deployment completed. Access the AWS Web UI for the Load Balancer address."