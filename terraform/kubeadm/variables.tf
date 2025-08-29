# kubeadm/variables.tf

variable "kubernetes_version" {
  description = "The Kubernetes version to deploy."
  type        = string
}

variable "master_nodes" {
  description = "The number of master nodes."
  type        = number
}

variable "worker_nodes" {
  description = "The number of worker nodes."
  type        = number
}

# Resource configuration variables
variable "master_cpu" {
  description = "Number of CPU cores for master nodes"
  type        = number
  default     = 2
}

variable "master_memory" {
  description = "Memory allocation for master nodes (e.g., '4G', '4096M')"
  type        = string
  default     = "4G"
}

variable "master_disk" {
  description = "Disk size for master nodes (e.g., '20G', '50G')"
  type        = string
  default     = "20G"
}

variable "worker_cpu" {
  description = "Number of CPU cores for worker nodes"
  type        = number
  default     = 2
}

variable "worker_memory" {
  description = "Memory allocation for worker nodes (e.g., '2G', '2048M')"
  type        = string
  default     = "2G"
}

variable "worker_disk" {
  description = "Disk size for worker nodes (e.g., '20G', '50G')"
  type        = string
  default     = "20G"
}
