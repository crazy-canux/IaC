terraform {
  required_version = ">= 1.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12.0"
    }
  }
}

# Configure Helm provider
provider "helm" {
  kubernetes {
    config_path = local.kubeconfig_path
  }
}

# Configure Kubernetes provider  
provider "kubernetes" {
  config_path = local.kubeconfig_path
}

# Configure Time provider
provider "time" {}
