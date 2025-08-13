output "middleware_project_name" {
  description = "Name of the middleware AppProject"
  value       = "middleware"
}

output "monitoring_project_name" {
  description = "Name of the monitoring AppProject"
  value       = "monitoring"
}

output "services_project_name" {
  description = "Name of the services AppProject"
  value       = "services"
}

output "jupyterhub_application_name" {
  description = "Name of the JupyterHub application"
  value       = "jupyterhub"
}

output "jupyterhub_namespace" {
  description = "Namespace where JupyterHub is deployed"
  value       = "jupyterhub"
}

output "cluster_name" {
  description = "Name of the cluster from Kind module"
  value       = local.cluster_name
}

output "cluster_endpoint" {
  description = "Cluster endpoint from Kind module"
  value       = local.cluster_endpoint
}

output "argocd_namespace" {
  description = "ArgoCD namespace"
  value       = local.argocd_namespace
}

output "environment" {
  description = "Environment configuration"
  value       = var.environment
}

output "jupyterhub_access_info" {
  description = "Information on how to access JupyterHub"
  value = {
    port_forward_command = "kubectl port-forward svc/proxy-public -n jupyterhub 8888:80"
    url                  = "http://localhost:8888"
    username             = "admin, jupyter, user1, or user2"
    password             = "jupyter"
    note                 = "Run port-forward command first, then access the URL"
  }
}

output "argocd_access_commands" {
  description = "Commands to access ArgoCD and check application status"
  value = {
    port_forward    = "kubectl port-forward svc/argocd-server -n argocd 8081:443"
    check_apps      = "kubectl get applications -n argocd"
    check_projects  = "kubectl get appprojects -n argocd"
    sync_jupyterhub = "argocd app sync jupyterhub"
  }
}
