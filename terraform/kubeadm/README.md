# Kubeadm Cluster Terraform Configuration

> **Note**: On macOS, it's not easy to use Multipass to create VMs for Kubernetes clusters because of network issues.

## Configuration Variables

### Required Variables

- `kubernetes_version`: The Kubernetes version to deploy
- `master_nodes`: The number of master nodes
- `worker_nodes`: The number of worker nodes

### Resource Configuration (Optional)

- `master_cpu`: Number of CPU cores for master nodes (default: 2)
- `master_memory`: Memory allocation for master nodes (default: "4G")
- `master_disk`: Disk size for master nodes (default: "20G")
- `worker_cpu`: Number of CPU cores for worker nodes (default: 2)
- `worker_memory`: Memory allocation for worker nodes (default: "2G")
- `worker_disk`: Disk size for worker nodes (default: "20G")

### Example Usage

```hcl
# Basic configuration
kubernetes_version = "v1.33.1"
master_nodes       = 1
worker_nodes       = 3

# Custom resource allocation
master_cpu    = 4
master_memory = "8G"
master_disk   = "50G"

worker_cpu    = 2
worker_memory = "4G"
worker_disk   = "30G"
```
