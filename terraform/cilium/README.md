# Cilium CNI Terraform Module

This Terraform module deploys Cilium CNI on a Kubernetes cluster using Helm charts.

## Prerequisites

- Kubernetes cluster (created by Kind module or other)
- Terraform >= 1.0
- Helm >= 3.0
- kubectl configured

## Usage

### Step 1: Deploy Kind cluster

```bash
cd terraform/kind
terraform init
terraform plan
terraform apply
```

### Step 2: Deploy Cilium CNI

```bash
cd ../cilium

# Get kubeconfig path from Kind cluster
KUBECONFIG_PATH=$(cd ../kind && terraform output -raw kubeconfig_path)
CLUSTER_NAME=$(cd ../kind && terraform output -raw cluster_name)

# Create terraform.tfvars
cat > terraform.tfvars << EOF
kubeconfig_path = "$KUBECONFIG_PATH"
cluster_name    = "$CLUSTER_NAME"
EOF

# Configure providers in providers.tf
cat >> providers.tf << EOF

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "time" {}
EOF

terraform init
terraform plan
terraform apply
```

## Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `kubeconfig_path` | Path to kubeconfig file | string | - | yes |
| `cluster_name` | Name of the Kubernetes cluster | string | - | yes |
| `cilium_version` | Cilium version to install | string | `"1.17.1"` | no |
| `environment` | Environment (development/production) | string | `"development"` | no |
| `enable_hubble_ui` | Enable Hubble UI | bool | `true` | no |

## Verification

After deployment, verify Cilium installation:

```bash
# Check Cilium pods
kubectl get pods -n kube-system -l k8s-app=cilium

# Check node status
kubectl get nodes

# Access Hubble UI (if enabled)
kubectl port-forward -n kube-system svc/hubble-ui 12000:80
```

## Troubleshooting

### Pull image issue

If you are using VPN, don't setup proxy for shell. Let docker use it's own proxy.
