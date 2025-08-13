# Data source to read Kind cluster state
data "terraform_remote_state" "kind" {
  backend = "local"

  config = {
    path = "../kind/terraform.tfstate"
  }
}

# Data source to read Cilium state (ensure CNI is ready)
data "terraform_remote_state" "cilium" {
  backend = "local"

  config = {
    path = "../cilium/terraform.tfstate"
  }
}

# Wait for Cilium to be ready before installing ArgoCD
resource "time_sleep" "wait_for_cilium" {
  create_duration = "30s"

  # Ensure we wait for Cilium to be completely ready
  depends_on = [data.terraform_remote_state.cilium]
}

# Create ArgoCD namespace
resource "kubernetes_namespace" "argocd" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.argocd_namespace
    labels = {
      "app.kubernetes.io/name"      = "argocd"
      "app.kubernetes.io/component" = "namespace"
      "environment"                 = var.environment
    }
  }

  depends_on = [time_sleep.wait_for_cilium]
}

# Local values for configuration
locals {
  # Get cluster info directly from Kind module outputs
  cluster_name        = data.terraform_remote_state.kind.outputs.cluster_name
  cluster_endpoint    = data.terraform_remote_state.kind.outputs.cluster_endpoint
  kubeconfig_path     = data.terraform_remote_state.kind.outputs.kubeconfig_file_path
  pod_subnet          = data.terraform_remote_state.kind.outputs.pod_subnet
  service_subnet      = data.terraform_remote_state.kind.outputs.service_subnet
  kubernetes_version  = data.terraform_remote_state.kind.outputs.kubernetes_version

  # Dynamic values based on configuration
  dynamic_values = {
    "global.domain"                            = var.ingress_hostname
    "server.service.type"                      = var.server_service_type
    "server.ingress.enabled"                   = var.enable_ingress
    "server.ingress.hosts[0]"                  = var.ingress_hostname
    "dex.enabled"                              = var.enable_dex
    "configs.secret.argocdServerAdminPassword" = var.admin_password != "" ? bcrypt(var.admin_password) : null
  }

  # Filter out null values and merge with additional values
  filtered_values = { for k, v in local.dynamic_values : k => v if v != null }
  merged_values   = merge(local.filtered_values, var.additional_values)
}

# Deploy ArgoCD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.helm_chart_version
  namespace  = var.argocd_namespace

  # Wait for namespace and cilium to be ready
  depends_on = [
    kubernetes_namespace.argocd,
    time_sleep.wait_for_cilium
  ]

  # Create namespace if not using kubernetes_namespace resource
  create_namespace = var.create_namespace ? false : true

  # Load values from file
  values = [
    file(var.values_file_path)
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
  timeout         = var.timeout
  recreate_pods   = true
}

# Wait for ArgoCD to be ready
resource "time_sleep" "wait_for_argocd" {
  count = var.wait_for_deployment ? 1 : 0

  create_duration = "60s"
  depends_on      = [helm_release.argocd]
}

# Get ArgoCD admin password if not provided
data "kubernetes_secret" "argocd_admin_password" {
  count = var.admin_password == "" ? 1 : 0

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = var.argocd_namespace
  }

  depends_on = [helm_release.argocd]
}
