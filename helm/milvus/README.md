# Milvus Helm Chart for Kind/ArgoCD

- 官方Chart: https://github.com/milvus-io/milvus-helm
- 本values.yaml适用于本地开发和ArgoCD自动化部署
- 默认启用standalone模式，关闭外部依赖和持久化
- 通过ingress暴露服务，访问 http://milvus.local
