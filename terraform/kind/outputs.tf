output "cluster_name" {
  description = "Name of the Kind cluster"
  value       = kind_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for the Kubernetes cluster"
  value       = kind_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "Base64 encoded cluster CA certificate"
  value       = kind_cluster.main.cluster_ca_certificate
  sensitive   = true
}

output "kubernetes_version" {
  description = "Kubernetes version of the cluster"
  value       = var.kubernetes_version
}

output "node_count" {
  description = "Total number of nodes in the cluster"
  value       = var.control_plane_count + var.worker_count
}

output "control_plane_count" {
  description = "Number of control plane nodes"
  value       = var.control_plane_count
}

output "worker_count" {
  description = "Number of worker nodes"
  value       = var.worker_count
}

output "cluster_ready" {
  description = "Indicates if the cluster is ready"
  value       = kind_cluster.main.completed
}

output "api_server_host" {
  description = "API server host for CNI configuration"
  value       = "${var.cluster_name}-control-plane"
}

output "api_server_port" {
  description = "API server port"
  value       = 6443
}

output "pod_subnet" {
  description = "Pod subnet CIDR"
  value       = var.pod_subnet
}

output "service_subnet" {
  description = "Service subnet CIDR"
  value       = var.service_subnet
}

output "cni_disabled" {
  description = "Whether default CNI is disabled"
  value       = var.disable_default_cni
}

output "kubeconfig_file_path" {
  description = "Path to the generated kubeconfig file"
  value       = local_file.kubeconfig.filename
}