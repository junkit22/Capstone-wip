#!/bin/bash

# Add Prometheus Helm repository
echo "Adding Prometheus Helm repository..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Update the local Helm repository
echo "Updating local Helm repository..."
helm repo update

# Define namespace and release name
NAMESPACE="monitoring"
RELEASE_NAME="prometheus-stack"  # Change this name as desired

# Create the namespace if it doesn't exist
echo "Ensuring namespace '$NAMESPACE' exists..."
kubectl get namespace $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Namespace '$NAMESPACE' not found. Creating it..."
    kubectl create namespace $NAMESPACE
else
    echo "Namespace '$NAMESPACE' already exists."
fi

# Install Prometheus stack in the monitoring namespace
echo "Installing Prometheus stack with release name: $RELEASE_NAME in namespace: $NAMESPACE"
helm install $RELEASE_NAME prometheus-community/kube-prometheus-stack --namespace $NAMESPACE

# Get Grafana admin password
echo "Retrieving Grafana admin password..."
GRAFANA_PASSWORD=$(kubectl get secret --namespace $NAMESPACE $RELEASE_NAME-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
echo "Grafana Admin Password: $GRAFANA_PASSWORD"

# Note to user
echo "Prometheus deployment completed in namespace '$NAMESPACE'."
