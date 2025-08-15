# ArgoCD Terraform Module

This Terraform module deploys ArgoCD to a Kubernetes cluster using Helm.

## Prerequisites

- Kubernetes cluster (deployed via `../kind/`)
- Cilium CNI (deployed via `../cilium/`)
- Helm provider configured
- kubectl configured with cluster access

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Plan the deployment:
   ```bash
   terraform plan
   ```

3. Apply the deployment:
   ```bash
   terraform apply
   ```

## Configuration

### Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| `helm_chart_version` | ArgoCD Helm chart version | string | "7.7.8" |
| `argocd_namespace` | Namespace for ArgoCD | string | "argocd" |
| `values_file_path` | Path to Helm values file | string | "../../helm/argocd/values.yaml" |
| `environment` | Environment (dev/staging/prod) | string | "production" |
| `wait_for_deployment` | Wait for deployment to be ready | bool | true |
| `timeout` | Deployment timeout in seconds | number | 600 |
| `server_service_type` | ArgoCD server service type | string | "ClusterIP" |
| `enable_ingress` | Enable ingress for ArgoCD | bool | false |
| `enable_dex` | Enable Dex OIDC | bool | false |
| `admin_password` | Custom admin password | string | "" (auto-generated) |

### Outputs

- `argocd_admin_username` - Admin username (always "admin")
- `argocd_admin_password` - Admin password (sensitive)
- `argocd_server_url` - URL to access ArgoCD
- `argocd_port_forward_command` - kubectl port-forward command
- `argocd_login_command` - ArgoCD CLI login command

## Accessing ArgoCD

### Port Forward (Default)
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Then access: https://localhost:8080

### Get Admin Password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### ArgoCD CLI Login
```bash
argocd login localhost:8080 --username admin --password <password> --insecure
```

## Dependencies

This module depends on:
- Kind cluster state from `../kind/terraform.tfstate`
- Cilium CNI state from `../cilium/terraform.tfstate`

## Architecture

The module deploys:
- ArgoCD Server (API/UI)
- ArgoCD Application Controller
- ArgoCD Repository Server
- Redis (for caching)
- ArgoCD Application Set Controller
- Kubernetes namespace (if enabled)

## Security

- All containers run as non-root
- Security contexts configured
- Network policies can be added
- RBAC configured by Helm chart
- Admin password is stored in Kubernetes secret

## Troubleshooting

### helm download issue

If you are using VPN, you have to setup proxy for shell. Otherwise, Helm will fail to download the chart.
