#!/bin/bash

# Namespace where Prometheus is running
NAMESPACE="monitoring"

# Ensure the namespace exists
echo "Ensuring namespace '$NAMESPACE' exists..."
kubectl get namespace $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Namespace '$NAMESPACE' not found. Creating it..."
    kubectl create namespace $NAMESPACE
    if [ $? -ne 0 ]; then
        echo "Failed to create namespace '$NAMESPACE'."
        exit 1
    fi
else
    echo "Namespace '$NAMESPACE' already exists."
fi

echo "Fetching Prometheus pod name in namespace '$NAMESPACE'..."

# Wait for the Prometheus pod to be ready
POD_NAME=""
for i in {1..10}; do
    POD_NAME=$(kubectl get pods --namespace=$NAMESPACE -o jsonpath="{.items[?(@.metadata.labels.app=='prometheus')].metadata.name}" 2>/dev/null)
    if [ -n "$POD_NAME" ]; then
        break
    fi
    echo "Waiting for Prometheus pod to be ready..."
    sleep 5
done

if [ -z "$POD_NAME" ]; then
    echo "Error: No Prometheus pod found in namespace '$NAMESPACE' after waiting."
    exit 1
fi

echo "Prometheus pod found: $POD_NAME"

# Set up port-forwarding to access Prometheus on localhost:8080
echo "Setting up port-forwarding to access Prometheus..."
kubectl port-forward --namespace=$NAMESPACE $POD_NAME 8080:9090 &

echo "Port-forwarding established. You can now access Prometheus at http://localhost:8080"
