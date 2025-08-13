variable "git_repository_url" {
  description = "Git repository URL containing the manifests"
  type        = string
  default     = "https://github.com/crazy-canux/IaC.git"
}

variable "git_target_revision" {
  description = "Git target revision (branch, tag, or commit)"
  type        = string
  default     = "HEAD"
}

variable "manifests_path" {
  description = "Path to manifests in the repository"
  type        = string
  default     = "manifests"
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

variable "auto_sync_enabled" {
  description = "Enable automatic sync for applications"
  type        = bool
  default     = true
}

variable "self_heal_enabled" {
  description = "Enable self-healing for applications"
  type        = bool
  default     = true
}

variable "prune_enabled" {
  description = "Enable pruning of resources"
  type        = bool
  default     = true
}
