# Create Kind cluster
resource "kind_cluster" "main" {
  name           = var.cluster_name
  node_image     = "kindest/node:${var.kubernetes_version}"
  wait_for_ready = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    networking {
      disable_default_cni = var.disable_default_cni
      kube_proxy_mode     = var.kube_proxy_mode != "none" ? var.kube_proxy_mode : null
      pod_subnet          = var.pod_subnet
      service_subnet      = var.service_subnet
    }

    # Control plane nodes
    dynamic "node" {
      for_each = range(var.control_plane_count)
      content {
        role  = "control-plane"
        image = "kindest/node:${var.kubernetes_version}"
      }
    }

    # Worker nodes
    dynamic "node" {
      for_each = range(var.worker_count)
      content {
        role  = "worker"
        image = "kindest/node:${var.kubernetes_version}"

        # Add port mappings only to the first worker node
        dynamic "extra_port_mappings" {
          for_each = node.key == 0 ? var.node_port_mappings : []
          content {
            container_port = extra_port_mappings.value.container_port
            host_port      = extra_port_mappings.value.host_port
            protocol       = extra_port_mappings.value.protocol
          }
        }

        # Add extra mounts if specified
        dynamic "extra_mounts" {
          for_each = var.extra_mounts
          content {
            host_path      = extra_mounts.value.host_path
            container_path = extra_mounts.value.container_path
            read_only      = extra_mounts.value.readonly
          }
        }
      }
    }
  }
}

# Wait for cluster to be ready
resource "time_sleep" "wait_for_cluster" {
  depends_on      = [kind_cluster.main]
  create_duration = "30s"
}
