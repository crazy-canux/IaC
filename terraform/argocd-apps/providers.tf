terraform {
  required_version = ">= 1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12.0"
    }
  }
}

# Configure Kubernetes provider - uses kubeconfig from Kind cluster  
provider "kubernetes" {
  config_path = "../kind/iac-lab-config"
}

# Configure kubectl provider for ArgoCD resources
provider "kubectl" {
  config_path = "../kind/iac-lab-config"
}

# Configure Time provider
provider "time" {}
