# Cilium Helm Values

This directory contains Helm values files for deploying Cilium CNI in different environments.

## Files

- `values.yaml` - Default values for development/Kind clusters
- `values-production.yaml` - Production-ready configuration

## Usage

### With Helm directly

```bash
# Development deployment
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium \
  --namespace kube-system \
  --values values.yaml

# Production deployment  
helm install cilium cilium/cilium \
  --namespace kube-system \
  --values values-production.yaml
```

### With Terraform module

The Terraform Cilium module automatically selects the appropriate values file based on the `environment` variable.

## Key Configuration Differences

### Development (values.yaml)
- Single operator replica
- Reduced resource requirements
- Hubble UI with NodePort
- Optimized for Kind clusters

### Production (values-production.yaml)
- High availability (2+ replicas)
- Higher resource limits
- Enhanced monitoring and metrics
- Pod anti-affinity rules
- ClusterIP services (use with ingress)

## Customization

You can override any values using the Terraform module's `additional_values` variable:

```terraform
module "cilium" {
  source = "./terraform/cilium"
  
  additional_values = {
    "operator.replicas" = 3
    "prometheus.enabled" = true
    "hubble.metrics.enabled[0]" = "dns"
    "hubble.metrics.enabled[1]" = "drop"
  }
}
```
