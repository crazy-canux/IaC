variable "helm_chart_version" {
  description = "Cilium Helm chart version"
  type        = string
  default     = "1.17.1"
}

variable "cilium_namespace" {
  description = "Namespace to install Cilium"
  type        = string
  default     = "kube-system"
}

variable "values_file_path" {
  description = "Path to the Helm values file"
  type        = string
  default     = "../../helm/cilium/values.yaml"
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
  description = "Wait for Cilium deployment to be ready"
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Timeout for Helm deployment in seconds"
  type        = number
  default     = 300
  validation {
    condition     = var.timeout > 0 && var.timeout <= 1800
    error_message = "Timeout must be between 1 and 1800 seconds (30 minutes)."
  }
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

variable "additional_values" {
  description = "Additional Helm values to merge with defaults"
  type        = map(any)
  default     = {}
}

variable "create_namespace" {
  description = "Create the namespace if it doesn't exist"
  type        = bool
  default     = false
}

variable "atomic" {
  description = "If set, installation process purges chart on fail"
  type        = bool
  default     = true
}

variable "cleanup_on_fail" {
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
  default     = true
}

variable "force_update" {
  description = "Force resource update through delete/recreate if needed"
  type        = bool
  default     = false
}

variable "reset_values" {
  description = "When upgrading, reset the values to the ones built into the chart"
  type        = bool
  default     = false
}

variable "reuse_values" {
  description = "When upgrading, reuse the last release's values and merge in overrides"
  type        = bool
  default     = false
}

variable "max_history" {
  description = "Maximum number of release revisions saved per release"
  type        = number
  default     = 10
}
