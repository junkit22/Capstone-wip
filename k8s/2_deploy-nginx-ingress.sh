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

# Define namespace and release name
NAMESPACE="monitoring"
RELEASE_NAME="nginx-ingress"  # Change this name as desired

# Create the namespace if it doesn't exist
echo "Ensuring namespace '$NAMESPACE' exists..."
kubectl get namespace $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Namespace '$NAMESPACE' not found. Creating it..."
    kubectl create namespace $NAMESPACE
else
    echo "Namespace '$NAMESPACE' already exists."
fi

# Install the NGINX Ingress Controller in the specified namespace
echo "Installing NGINX Ingress Controller with release name: $RELEASE_NAME in namespace: $NAMESPACE"
helm install $RELEASE_NAME ingress-nginx/ingress-nginx --namespace $NAMESPACE

# Check the status of services
echo "Checking for Ingress Controller services in namespace: $NAMESPACE"
kubectl get svc --namespace $NAMESPACE

# Check the status of pods
echo "Checking for Ingress Controller pods in namespace: $NAMESPACE"
kubectl get pods --namespace $NAMESPACE

# Apply your ingress configuration
echo "Applying ingress configuration from ingress.yaml in namespace: $NAMESPACE..."
kubectl apply -f ingress.yaml --namespace $NAMESPACE

# Apply Flask app configuration
echo "Applying Flask app configuration from flask-app.yaml in namespace: $NAMESPACE..."
kubectl apply -f flask-app.yaml --namespace $NAMESPACE

# Check ingress resources
echo "Checking ingress resources in namespace: $NAMESPACE..."
kubectl get ingress --namespace $NAMESPACE

# Note to user
echo "Deployment completed in namespace '$NAMESPACE'. Access the AWS Web UI for the Load Balancer address."
