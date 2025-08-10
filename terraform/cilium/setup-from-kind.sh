#!/bin/bash

# Script to set up Cilium module using Kind module outputs
set -e

echo "🔄 Setting up Cilium module with Kind cluster outputs..."

# Check if we're in the cilium directory
if [[ ! -f "variables.tf" ]] || [[ ! $(grep -q "kubeconfig_path" variables.tf) ]]; then
    echo "❌ Error: Please run this script from the terraform/cilium directory"
    exit 1
fi

# Check if Kind module exists and has been applied
if [[ ! -d "../kind" ]]; then
    echo "❌ Error: Kind module not found at ../kind"
    exit 1
fi

echo "📋 Getting outputs from Kind module..."
cd ../kind

# Check if terraform state exists
if [[ ! -f "terraform.tfstate" ]]; then
    echo "❌ Error: Kind cluster not deployed yet. Please run 'terraform apply' in the kind directory first."
    exit 1
fi

# Get outputs from Kind module
KUBECONFIG_PATH=$(terraform output -raw kubeconfig_path 2>/dev/null || echo "")
CLUSTER_NAME=$(terraform output -raw cluster_name 2>/dev/null || echo "")

if [[ -z "$KUBECONFIG_PATH" ]] || [[ -z "$CLUSTER_NAME" ]]; then
    echo "❌ Error: Could not get required outputs from Kind module"
    echo "   Make sure Kind cluster is deployed and working"
    exit 1
fi

echo "✅ Got Kind cluster info:"
echo "   Cluster Name: $CLUSTER_NAME"
echo "   Kubeconfig: $KUBECONFIG_PATH"

# Go back to cilium directory
cd ../cilium

# Create terraform.tfvars
echo "📝 Creating terraform.tfvars..."
cat > terraform.tfvars << EOF
# Auto-generated from Kind module outputs
kubeconfig_path = "$KUBECONFIG_PATH"
cluster_name    = "$CLUSTER_NAME"
EOF

echo "✅ Created terraform.tfvars with Kind cluster information"
echo "🚀 You can now run:"
echo "   terraform init"
echo "   terraform plan"
echo "   terraform apply"
