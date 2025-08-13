# NGINX Ingress Controller

This directory contains the NGINX Ingress Controller configuration for the Kind cluster.

## Overview

NGINX Ingress Controller provides HTTP and HTTPS routing to services in the cluster, enabling access via domain names instead of port-forwarding.

## Configuration

- **Service Type**: NodePort with port mappings (30080:80, 30443:443)
- **Mode**: DaemonSet for better performance in Kind
- **Admission Webhooks**: Disabled for local development
- **Resource Limits**: Optimized for local development

## Access

With the ingress controller deployed and local DNS configured, you can access services via:

- ArgoCD: `http://argocd.local:8080`
- JupyterHub: `http://jupyterhub.local:8080`

## Local DNS Setup

Add these entries to your `/etc/hosts` file:

```bash
sudo tee -a /etc/hosts << 'EOF'

# Kind cluster services
127.0.0.1 argocd.local
127.0.0.1 jupyterhub.local
EOF
```

## Port Mappings

The Kind cluster is configured with these port mappings:

- Container port 80 → Host port 8080
- Container port 443 → Host port 8443

## Deployment

This ingress controller is deployed via ArgoCD using the GitOps pattern:

1. Helm values are stored in `helm/ingress-nginx/values.yaml`
2. ArgoCD Application is defined in `manifests/ingress-nginx/application.yaml`
3. Values are pulled from GitHub repository during deployment
