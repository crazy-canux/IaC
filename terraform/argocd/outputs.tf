output "argocd_release_name" {
  description = "Name of the ArgoCD Helm release"
  value       = helm_release.argocd.name
}

output "argocd_namespace" {
  description = "Namespace where ArgoCD is installed"
  value       = helm_release.argocd.namespace
}

output "argocd_version" {
  description = "Installed ArgoCD version"
  value       = helm_release.argocd.version
}

output "helm_chart_version" {
  description = "ArgoCD Helm chart version used"
  value       = helm_release.argocd.version
}

output "argocd_status" {
  description = "Status of the ArgoCD Helm release"
  value       = helm_release.argocd.status
}

output "environment" {
  description = "Environment configuration used"
  value       = var.environment
}

# Cluster information (from Kind)
output "cluster_name" {
  description = "Name of the cluster from Kind module"
  value       = local.cluster_name
}

output "cluster_endpoint" {
  description = "Cluster endpoint from Kind module"
  value       = local.cluster_endpoint
}

output "kubeconfig_path" {
  description = "Path to kubeconfig file"
  value       = local.kubeconfig_path
}

output "pod_subnet" {
  description = "Pod subnet CIDR"
  value       = local.pod_subnet
}

output "service_subnet" {
  description = "Service subnet CIDR"
  value       = local.service_subnet
}

output "kubernetes_version" {
  description = "Kubernetes version"
  value       = local.kubernetes_version
}

# ArgoCD specific outputs for applications
output "argocd_server_service_name" {
  description = "ArgoCD server service name"
  value       = "argocd-server"
}

output "argocd_server_port" {
  description = "ArgoCD server port"
  value       = 443
}

output "argocd_repo_server_service_name" {
  description = "ArgoCD repository server service name"
  value       = "argocd-repo-server"
}

output "argocd_application_controller_service_name" {
  description = "ArgoCD application controller service name"
  value       = "argocd-application-controller"
}

output "argocd_server_service_type" {
  description = "Service type for ArgoCD server"
  value       = var.server_service_type
}

output "argocd_server_url" {
  description = "URL to access ArgoCD server"
  value = var.server_service_type == "ClusterIP" ? (
    var.enable_ingress ? "https://${var.ingress_hostname}" : "http://localhost:8080 (use port-forward)"
  ) : "Check service for external access"
}

output "argocd_admin_username" {
  description = "ArgoCD admin username"
  value       = "admin"
}

output "argocd_admin_password" {
  description = "ArgoCD admin password (auto-generated if not provided)"
  value = var.admin_password != "" ? (
    "*** Custom password provided ***"
  ) : (
    length(data.kubernetes_secret.argocd_admin_password) > 0 && 
    can(data.kubernetes_secret.argocd_admin_password[0].data["password"]) ? 
    try(base64decode(data.kubernetes_secret.argocd_admin_password[0].data["password"]), "Password decode failed") :
    "Password not yet available - ArgoCD may still be initializing"
  )
  sensitive = true
}

output "argocd_port_forward_command" {
  description = "Command to port-forward to ArgoCD server"
  value       = "kubectl port-forward svc/argocd-server -n ${var.argocd_namespace} 8080:443"
}

output "argocd_get_password_command" {
  description = "Command to get ArgoCD admin password"
  value       = "kubectl -n ${var.argocd_namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

output "argocd_login_command" {
  description = "Command to login to ArgoCD CLI"
  value = var.admin_password != "" ? (
    "argocd login localhost:8080 --username admin --password <your-password> --insecure"
    ) : (
    "argocd login localhost:8080 --username admin --password $(kubectl -n ${var.argocd_namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d) --insecure"
  )
  sensitive = true
}
