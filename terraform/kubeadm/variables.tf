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
