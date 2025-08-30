# Milvus WebUI Ingress
# Simple ingress for Milvus WebUI on port 9091

resource "kubectl_manifest" "milvus_webui_ingress" {
  yaml_body = yamlencode({
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"

    metadata = {
      name      = "milvus-webui"
      namespace = "milvus"
      annotations = {
        "nginx.ingress.kubernetes.io/backend-protocol"     = "HTTP"
        "nginx.ingress.kubernetes.io/ssl-redirect"         = "false"
        "nginx.ingress.kubernetes.io/force-ssl-redirect"   = "false"
      }
    }

    spec = {
      ingressClassName = "nginx"
      rules = [{
        host = "milvus.local"
        http = {
          paths = [{
            path     = "/"
            pathType = "Prefix"
            backend = {
              service = {
                name = "milvus"
                port = {
                  number = 9091
                }
              }
            }
          }]
        }
      }]
    }
  })

  depends_on = [
    kubectl_manifest.milvus_application,
  ]
}
