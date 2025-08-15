# Kind Cluster Terraform Configuration

This Terraform configuration creates a local Kubernetes cluster using Kind (Kubernetes in Docker).

## Features

- Configurable number of control plane and worker nodes
- Support for custom CNI (disabled by default for Cilium installation)
- Configurable kube-proxy mode
- Port mappings for ingress access
- Host directory mounting support
- Automatic kubeconfig generation

## Configuration

### Basic Usage

```bash
# Initialize Terraform
terraform init

# Create cluster with default settings
terraform apply

# Destroy cluster
terraform destroy
```

### Variables

- `cluster_name`: Name of the Kind cluster (default: "iac-lab")
- `kubernetes_version`: Kubernetes version (default: "v1.33.1")
- `control_plane_count`: Number of control plane nodes (default: 1)
- `worker_count`: Number of worker nodes (default: 3)
- `disable_default_cni`: Disable default CNI for custom CNI installation (default: true)
- `kube_proxy_mode`: Kube-proxy mode - none, iptables, or ipvs (default: "none")
- `pod_subnet`: Pod CIDR subnet (default: "10.244.0.0/16")
- `service_subnet`: Service CIDR subnet (default: "10.96.0.0/12")
- `host_share_dir`: Host directory to mount in nodes (optional)
- `host_share_mount_path`: Container path for host directory mount (default: "/mnt/host")

### Port Mappings

Configure port mappings for ingress:

```hcl
node_port_mappings = [
  {
    container_port = 30080
    host_port      = 8080
    protocol       = "TCP"
  },
  {
    container_port = 30443
    host_port      = 8443
    protocol       = "TCP"
  }
]
```

## Proxy Configuration

If you need proxy support for image pulls in a corporate environment, configure Docker daemon proxy settings on your host machine. Kind will inherit these settings automatically.

## Generated Files

- `{cluster_name}-config`: Kubeconfig file for cluster access

## Usage with Cilium

This configuration is optimized for Cilium CNI:

1. Default CNI is disabled (`disable_default_cni = true`)
2. Kube-proxy is disabled (`kube_proxy_mode = "none"`)
3. Multiple worker nodes for testing connectivity

After cluster creation, install Cilium using the `../cilium` Terraform configuration.

## Troubleshooting

### Port Conflicts

If ports 8080 or 8443 are already in use, modify the `node_port_mappings` variable to use different host ports.
