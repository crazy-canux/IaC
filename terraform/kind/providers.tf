terraform {
  required_version = ">= 1.0"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.6.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12.0"
    }
  }
}

# Configure the Kind Provider
provider "kind" {}

# Configure Time provider for wait resources
provider "time" {}
