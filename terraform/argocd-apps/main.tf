# Data source to read Kind cluster state
data "terraform_remote_state" "kind" {
  backend = "local"

  config = {
    path = "../kind/terraform.tfstate"
  }
}

# Data source to read Cilium state
data "terraform_remote_state" "cilium" {
  backend = "local"

  config = {
    path = "../cilium/terraform.tfstate"
  }
}

# Data source to read ArgoCD state
data "terraform_remote_state" "argocd" {
  backend = "local"

  config = {
    path = "../argocd/terraform.tfstate"
  }
}

# Local values for configuration
locals {
  # Get cluster info from remote states
  cluster_name     = data.terraform_remote_state.kind.outputs.cluster_name
  cluster_endpoint = data.terraform_remote_state.kind.outputs.cluster_endpoint
  argocd_namespace = data.terraform_remote_state.argocd.outputs.argocd_namespace

  # Common labels
  common_labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/part-of"    = "argocd"
    "environment"                  = var.environment
  }
}

# Deploy AppProjects
resource "kubectl_manifest" "middleware_project" {
  yaml_body = file("../../manifests/projects/middleware.yaml")

  depends_on = [data.terraform_remote_state.argocd]
}

resource "kubectl_manifest" "monitoring_project" {
  yaml_body = file("../../manifests/projects/monitoring.yaml")

  depends_on = [data.terraform_remote_state.argocd]
}

resource "kubectl_manifest" "services_project" {
  yaml_body = file("../../manifests/projects/services.yaml")

  depends_on = [data.terraform_remote_state.argocd]
}

# Deploy NGINX Ingress Controller
resource "kubectl_manifest" "ingress_nginx_application" {
  yaml_body = file("../../manifests/ingress-nginx/application.yaml")

  depends_on = [
    kubectl_manifest.middleware_project,
    data.terraform_remote_state.argocd
  ]
}

# Deploy JupyterHub Application
resource "kubectl_manifest" "jupyterhub_application" {
  yaml_body = file("../../manifests/jupyterhub/application.yaml")

  depends_on = [
    kubectl_manifest.services_project,
    data.terraform_remote_state.argocd
  ]
}

# Wait for ArgoCD applications to be ready
resource "time_sleep" "wait_for_applications" {
  create_duration = "30s"

  depends_on = [
    kubectl_manifest.jupyterhub_application
  ]
}
