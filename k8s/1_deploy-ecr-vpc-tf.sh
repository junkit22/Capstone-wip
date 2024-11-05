#!/bin/bash

# Define the directory where Terraform files are located
TF_DIR="../terraform"

# Change to the Terraform directory
if cd "$TF_DIR"; then
    echo "Navigated to Terraform directory: $TF_DIR"
else
    echo "Failed to navigate to Terraform directory: $TF_DIR"
    exit 1
fi

# Initialize Terraform (required before running plan and apply)
echo "Initializing Terraform..."
terraform init -input=false
if [ $? -ne 0 ]; then
    echo "Terraform initialization failed."
    exit 1
fi

# Run Terraform plan
echo "Running Terraform plan..."
terraform plan -out=tfplan -input=false
if [ $? -ne 0 ]; then
    echo "Terraform plan failed."
    exit 1
fi

# Run Terraform apply
echo "Running Terraform apply..."
terraform apply -input=false tfplan
if [ $? -ne 0 ]; then
    echo "Terraform apply failed."
    exit 1
fi

echo "Terraform apply completed successfully."
