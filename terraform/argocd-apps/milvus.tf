# Milvus Ingress Configuration
# Handles both gRPC (port 19530) and WebUI (port 9091) traffic

resource "kubectl_manifest" "milvus_ingress" {
  yaml_body = yamlencode({
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"

    metadata = {
      name      = "milvus"
      namespace = "milvus"
      annotations = {
        "nginx.ingress.kubernetes.io/ssl-redirect"         = "false"
        "nginx.ingress.kubernetes.io/force-ssl-redirect"   = "false"
        "nginx.ingress.kubernetes.io/use-regex"            = "true"
      }
    }

    spec = {
      ingressClassName = "nginx"
      rules = [{
        host = "milvus.local"
        http = {
          paths = [
            # WebUI path - HTTP backend
            {
              path     = "/webui(/|$)(.*)"
              pathType = "Prefix"
              backend = {
                service = {
                  name = "milvus"
                  port = {
                    number = 9091
                  }
                }
              }
            },
            # Default path - gRPC backend
            {
              path     = "/"
              pathType = "Prefix"
              backend = {
                service = {
                  name = "milvus"
                  port = {
                    number = 19530
                  }
                }
              }
            }
          ]
        }
      }]
    }
  })

  depends_on = [
    kubectl_manifest.milvus_application,
  ]
}
