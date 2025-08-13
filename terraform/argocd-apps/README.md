# ArgoCD Applications Terraform Module

This Terraform module deploys ArgoCD AppProjects and Applications for managing the entire infrastructure using GitOps.

## Prerequisites

- Kind cluster deployed (`../kind/`)
- Cilium CNI deployed (`../cilium/`)
- ArgoCD deployed (`../argocd/`)

## What This Module Deploys

### AppProjects
1. **middleware** - For infrastructure services (cert-manager, ingress-nginx, external-dns)
2. **monitoring** - For observability services (Grafana, Prometheus, Loki)
3. **services** - For application services (JupyterHub, etc.)

### Applications
1. **JupyterHub** - Multi-user Jupyter notebook server

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
| `git_repository_url` | Git repository URL containing manifests | string | "https://github.com/crazy-canux/IaC.git" |
| `git_target_revision` | Git target revision (branch/tag/commit) | string | "HEAD" |
| `manifests_path` | Path to manifests in repository | string | "manifests" |
| `environment` | Environment (dev/staging/prod) | string | "development" |
| `auto_sync_enabled` | Enable automatic sync | bool | true |
| `self_heal_enabled` | Enable self-healing | bool | true |
| `prune_enabled` | Enable resource pruning | bool | true |

### Outputs

- AppProject and Application names
- Access information for JupyterHub
- ArgoCD management commands
- Cluster information

## Accessing JupyterHub

After deployment:

1. **Port Forward**:
   ```bash
   kubectl port-forward svc/proxy-public -n jupyterhub 8888:80
   ```

2. **Access**: http://localhost:8888

3. **Login**:
   - Username: `admin`, `jupyter`, `user1`, or `user2`
   - Password: `jupyter`

## Managing Applications

### Check Application Status
```bash
kubectl get applications -n argocd
kubectl get appprojects -n argocd
```

### Sync Applications Manually
```bash
argocd app sync jupyterhub
```

### View Application Details
```bash
argocd app get jupyterhub
```

## Dependencies

This module depends on:
- Kind cluster state from `../kind/terraform.tfstate`
- Cilium CNI state from `../cilium/terraform.tfstate`
- ArgoCD state from `../argocd/terraform.tfstate`

## GitOps Workflow

1. **Infrastructure Changes**: Modify files in `manifests/` directory
2. **Git Commit**: Push changes to repository
3. **Automatic Sync**: ArgoCD automatically applies changes (if auto-sync enabled)
4. **Manual Sync**: Use `argocd app sync <app-name>` for manual deployment

## Security Notes

- JupyterHub uses DummyAuthenticator for development
- Change authentication method for production use
- Review and adjust RBAC permissions as needed
- Consider network policies for production deployments
