output "cilium_release_name" {
  description = "Name of the Cilium Helm release"
  value       = helm_release.cilium.name
}

output "cilium_namespace" {
  description = "Namespace where Cilium is installed"
  value       = helm_release.cilium.namespace
}

output "cilium_version" {
  description = "Installed Cilium version"
  value       = var.cilium_version
}

output "helm_chart_version" {
  description = "Cilium Helm chart version used"
  value       = helm_release.cilium.version
}

output "cilium_status" {
  description = "Status of the Cilium Helm release"
  value       = helm_release.cilium.status
}

output "hubble_ui_enabled" {
  description = "Whether Hubble UI is enabled"
  value       = var.enable_hubble_ui
}

output "kube_proxy_replacement" {
  description = "Whether Cilium kube-proxy replacement is enabled"
  value       = var.kube_proxy_replacement
}

output "environment" {
  description = "Environment where Cilium is deployed"
  value       = var.environment
}

output "cluster_name" {
  description = "Name of the cluster where Cilium is deployed"
  value       = var.cluster_name
}

output "values_file_used" {
  description = "Path to the values file used"
  value       = local.values_file
}

output "verification_commands" {
  description = "Commands to verify Cilium installation"
  value = [
    "kubectl get pods -n ${var.cilium_namespace} -l k8s-app=cilium",
    "kubectl get nodes",
    "cilium status --wait",
    var.enable_hubble_ui ? "kubectl port-forward -n ${var.cilium_namespace} svc/hubble-ui 12000:80" : null
  ]
}
