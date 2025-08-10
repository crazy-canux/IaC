# Data source to read Kind cluster state
data "terraform_remote_state" "kind" {
  backend = "local"

  config = {
    path = "../kind/terraform.tfstate"
  }
}

# Wait for cluster to be ready before installing Cilium
resource "time_sleep" "wait_for_cluster" {
  create_duration = "30s"
}

# Determine values file based on environment
locals {
  values_file = var.environment == "production" ? "../../helm/cilium/values-production.yaml" : var.values_file_path

  # Get cluster info from Kind module state
  cluster_name = try(data.terraform_remote_state.kind.outputs.cluster_name, var.cluster_name)
  
  # Use default kubeconfig location since Kind updates ~/.kube/config
  kubeconfig_path = var.kubeconfig_path != "" ? var.kubeconfig_path : "~/.kube/config"

  # Dynamic values based on Kind cluster
  dynamic_values = {
    "cluster.name"         = local.cluster_name
    "k8sServiceHost"       = "${local.cluster_name}-control-plane"
    "k8sServicePort"       = 6443
    "kubeProxyReplacement" = var.kube_proxy_replacement
    "hubble.ui.enabled"    = var.enable_hubble_ui
    "image.pullPolicy"     = "IfNotPresent"
    "ipam.mode"            = "kubernetes"
  }

  # Merge with additional values
  merged_values = merge(local.dynamic_values, var.additional_values)
}

# Deploy Cilium using Helm
resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = var.helm_chart_version
  namespace  = var.cilium_namespace

  # Wait for cluster to be ready
  depends_on = [time_sleep.wait_for_cluster]

  # Load values from file
  values = [
    file(local.values_file)
  ]

  # Dynamic set values
  dynamic "set" {
    for_each = local.merged_values
    content {
      name  = set.key
      value = set.value
    }
  }

  # Cleanup on fail and wait for deployment
  cleanup_on_fail = true
  wait            = var.wait_for_deployment
  timeout         = 300  # Reduced from 600 to 5 minutes
  recreate_pods   = true
}

# Wait for Cilium to be ready
resource "time_sleep" "wait_for_cilium" {
  count = var.wait_for_deployment ? 1 : 0

  create_duration = "30s"  # Reduced from 60s
  depends_on      = [helm_release.cilium]
}
