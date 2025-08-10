variable "kubeconfig_path" {
  description = "Path to the kubeconfig file from Kind cluster (auto-detected if not provided)"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster from Kind module (auto-detected if not provided)"
  type        = string
  default     = ""
}

variable "cilium_version" {
  description = "Cilium version to install"
  type        = string
  default     = "1.17.1"
  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.cilium_version))
    error_message = "Cilium version must be in format 'X.Y.Z' (e.g., '1.17.1')."
  }
}

variable "cilium_namespace" {
  description = "Namespace to install Cilium"
  type        = string
  default     = "kube-system"
}

variable "helm_chart_version" {
  description = "Cilium Helm chart version"
  type        = string
  default     = "1.17.1"
}

variable "values_file_path" {
  description = "Path to the Helm values file"
  type        = string
  default     = "../../helm/cilium/values.yaml"
}

variable "environment" {
  description = "Environment (development, staging, production)"
  type        = string
  default     = "development"
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production."
  }
}

variable "enable_hubble_ui" {
  description = "Enable Hubble UI for observability"
  type        = bool
  default     = true
}

variable "kube_proxy_replacement" {
  description = "Enable Cilium kube-proxy replacement"
  type        = bool
  default     = true
}

variable "wait_for_deployment" {
  description = "Wait for Cilium deployment to be ready"
  type        = bool
  default     = true
}

variable "additional_values" {
  description = "Additional Helm values to override"
  type        = map(any)
  default     = {}
}
