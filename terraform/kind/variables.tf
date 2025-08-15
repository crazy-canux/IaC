variable "cluster_name" {
  description = "Name of the Kind cluster"
  type        = string
  default     = "iac-lab"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "v1.33.1"
  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.kubernetes_version))
    error_message = "Kubernetes version must be in format 'vX.Y.Z' (e.g., 'v1.33.1')."
  }
}

variable "control_plane_count" {
  description = "Number of control plane nodes"
  type        = number
  default     = 1
  validation {
    condition     = var.control_plane_count >= 1 && var.control_plane_count <= 3
    error_message = "Control plane count must be between 1 and 3."
  }
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 3
  validation {
    condition     = var.worker_count >= 0 && var.worker_count <= 10
    error_message = "Worker count must be between 0 and 10."
  }
}

variable "disable_default_cni" {
  description = "Disable default CNI (useful for installing custom CNI like Cilium)"
  type        = bool
  default     = true
}

variable "kube_proxy_mode" {
  description = "Kube-proxy mode (none, iptables, ipvs)"
  type        = string
  default     = "none"
  validation {
    condition     = contains(["none", "iptables", "ipvs"], var.kube_proxy_mode)
    error_message = "Kube-proxy mode must be one of: none, iptables, ipvs."
  }
}



variable "pod_subnet" {
  description = "Pod subnet CIDR"
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_subnet" {
  description = "Service subnet CIDR"
  type        = string
  default     = "10.96.0.0/12"
}

variable "node_port_mappings" {
  description = "Port mappings for worker nodes"
  type = list(object({
    container_port = number
    host_port      = number
    protocol       = string
  }))
  default = [
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
}

variable "extra_mounts" {
  description = "Extra mounts for nodes"
  type = list(object({
    host_path      = string
    container_path = string
    readonly       = bool
  }))
  default = []
}

# Host folder sharing into kind nodes (for JupyterHub access)
variable "host_share_dir" {
  description = "Absolute path on macOS to share into kind nodes (e.g. /Users/<you>/jupyterhub). Leave empty to disable."
  type        = string
  default     = "/Users/canux/jupyterhub"
}

variable "host_share_mount_path" {
  description = "Path inside kind nodes where the host folder will be mounted."
  type        = string
  default     = "/mnt/host/jupyterhub"
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default = {
    managed-by = "terraform"
    project    = "kind-cluster"
  }
}
