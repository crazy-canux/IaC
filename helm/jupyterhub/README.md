# JupyterHub Helm Values

This directory contains Helm values configuration for JupyterHub deployment using the Zero to JupyterHub with Kubernetes project.

## GitOps Configuration

This configuration is deployed using ArgoCD with a **multiple sources** approach:

- **Helm Chart Source**: Official JupyterHub chart from `https://hub.jupyter.org/helm-chart/`
- **Values Source**: This GitHub repository for configuration management

### Benefits of GitHub-based Values

- ✅ **Version Control**: All configuration changes tracked in Git
- ✅ **GitOps Compliance**: Full Infrastructure as Code approach
- ✅ **Environment Separation**: Different values files for dev/staging/prod
- ✅ **Audit Trail**: Complete history of configuration changes
- ✅ **Collaboration**: Team can review changes via Pull Requests

## Configuration Overview

The values file configures:

- **Proxy**: ChartProxy and Traefik for routing with resource limits
- **Hub**: JupyterHub main application with SQLite database
- **Authentication**: DummyAuthenticator for testing (change in production)
- **Single-user**: Notebook server configuration with resource limits
- **Storage**: Persistent storage for both hub and user notebooks
- **Network**: Configured for Kind cluster (no ingress, uses port-forward)

## Key Features

- **Development Ready**: Configured for Kind cluster testing
- **Resource Optimized**: Appropriate limits for local development
- **Persistent Storage**: User notebooks persist between sessions
- **Multi-user Support**: Ready for multiple simultaneous users
- **JupyterLab**: Default to JupyterLab interface
- **Z2JH Compliant**: Follows official Zero to JupyterHub specifications

## Default Credentials

- **Username**: `admin`, `jupyter`, `user1`, or `user2`
- **Password**: `jupyter` (for all users)

## Access Methods

### Local Development (Kind)
```bash
# Port forward to access JupyterHub
kubectl port-forward svc/proxy-public 8888:80 -n jupyterhub

# Access at http://localhost:8888
```

### Production
Configure ingress in values file for external access with proper domain and TLS.

## Storage

- **Hub Database**: 1Gi SQLite PVC
- **User Storage**: 2Gi per user with persistent home directories
- **Storage Class**: `standard` (Kind default)

## Configuration Management

### Making Changes

1. **Edit Values**: Modify `values.yaml` in this repository
2. **Commit & Push**: Push changes to GitHub
3. **ArgoCD Sync**: ArgoCD automatically detects and applies changes

### Environment-Specific Configuration

Create additional values files for different environments:
- `values.yaml` - Development/Kind cluster
- `values-staging.yaml` - Staging environment  
- `values-production.yaml` - Production environment

Update ArgoCD application to use appropriate values file per environment.

## Validation

A comprehensive validation notebook is available at:
- `validation/jupyterhub-compliance-check.ipynb`

This notebook validates the deployment against Z2JH specifications and provides health monitoring.

## Customization

To customize the deployment:

1. Edit `values.yaml` for configuration changes
2. Update the ArgoCD application if chart version changes
3. Use environment-specific values files for different deployments

## Security Notes

⚠️ **This configuration is for development/testing only:**
- Uses DummyAuthenticator with simple passwords
- No TLS/SSL configuration
- No network policies enabled
- Simplified RBAC

For production use:
- Configure proper authentication (OAuth, LDAP, etc.)
- Enable TLS with proper certificates  
- Implement network policies
- Use stronger passwords/secrets
- Configure resource quotas
- Enable monitoring and logging

## Reference

- [Zero to JupyterHub Documentation](https://z2jh.jupyter.org/)
- [ArgoCD Multiple Sources](https://argo-cd.readthedocs.io/en/stable/user-guide/multiple_sources/)
- [JupyterHub Helm Chart](https://hub.jupyter.org/helm-chart/)
