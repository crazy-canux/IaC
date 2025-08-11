variable "environment" {
  description = "Environment (development, staging, production)"
  type        = string
  default     = "development"
}

variable "values_file_path" {
  description = "Path to the Helm values file for development"
  type        = string
  default     = "../../helm/cilium/values.yaml"
}

variable "kube_proxy_replacement" {
  description = "Enable Cilium kube-proxy replacement"
  type        = bool
  default     = true
}

variable "enable_hubble_ui" {
  description = "Enable Hubble UI for network observability"
  type        = bool
  default     = true
}

variable "wait_for_deployment" {
  description = "Wait for Cilium deployment to be ready"
  type        = bool
  default     = true
}

variable "additional_values" {
  description = "Additional Helm values to merge with defaults"
  type        = map(any)
  default     = {}
}
