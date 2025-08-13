variable "helm_chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "7.7.8"
}

variable "argocd_namespace" {
  description = "Namespace to install ArgoCD"
  type        = string
  default     = "argocd"
}

variable "values_file_path" {
  description = "Path to the Helm values file"
  type        = string
  default     = "../../helm/argocd/values.yaml"
}

variable "environment" {
  description = "Environment (development, staging, production)"
  type        = string
  default     = "production"
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production."
  }
}

variable "wait_for_deployment" {
  description = "Wait for ArgoCD deployment to be ready"
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Timeout for Helm deployment in seconds"
  type        = number
  default     = 600
  validation {
    condition     = var.timeout > 0 && var.timeout <= 1800
    error_message = "Timeout must be between 1 and 1800 seconds (30 minutes)."
  }
}

variable "create_namespace" {
  description = "Create the ArgoCD namespace if it doesn't exist"
  type        = bool
  default     = true
}

variable "additional_values" {
  description = "Additional Helm values to merge with the values file"
  type        = map(any)
  default     = {}
}

variable "server_service_type" {
  description = "Service type for ArgoCD server (ClusterIP, NodePort, LoadBalancer)"
  type        = string
  default     = "ClusterIP"
  validation {
    condition     = contains(["ClusterIP", "NodePort", "LoadBalancer"], var.server_service_type)
    error_message = "Service type must be one of: ClusterIP, NodePort, LoadBalancer."
  }
}

variable "enable_ingress" {
  description = "Enable ingress for ArgoCD server"
  type        = bool
  default     = false
}

variable "ingress_hostname" {
  description = "Hostname for ArgoCD ingress"
  type        = string
  default     = "argocd.local"
}

variable "enable_dex" {
  description = "Enable Dex for OIDC authentication"
  type        = bool
  default     = false
}

variable "admin_password" {
  description = "Admin password for ArgoCD (leave empty for auto-generated)"
  type        = string
  default     = ""
  sensitive   = true
}
