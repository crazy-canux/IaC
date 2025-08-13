# ArgoCD Helm Values

This directory contains Helm values configuration for ArgoCD deployment.

## Files

- `values.yaml` - Production-ready ArgoCD configuration

## Configuration Overview

The values file configures:

- **Server**: ArgoCD API server with ClusterIP service
- **Controller**: Application controller for managing applications
- **Repository Server**: Git repository management
- **Redis**: Cache and session storage
- **Application Set**: Managing multiple applications
- **Security**: Non-root containers with proper security contexts
- **Resources**: CPU and memory limits for all components

## Key Features

- Production-ready resource limits
- Security hardened with non-root containers
- Disabled Dex (OIDC) by default for simplicity
- Disabled Prometheus metrics by default
- Known hosts configuration for Git repositories
- Scalable architecture ready for HA deployment

## Usage

This values file is used by the Terraform module in `../../terraform/argocd/` to deploy ArgoCD to the Kubernetes cluster.

## Customization

To customize the deployment:

1. Edit `values.yaml` for Helm-specific configurations
2. Use Terraform variables in the ArgoCD module for runtime configurations
3. Override specific values using the `additional_values` variable in Terraform
