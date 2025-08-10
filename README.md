# IaC

GitOps + Terraform + Helm + Kubernetes

## Platform

Use kind or kubeadm to create a Kubernetes cluster.

## CNI

Use Cilium as the CNI for Kubernetes clusters.

## vault

Use vault to deploy vault server.

## bank-vaults

Bank-vaults used to inject secrets from vaults to pods.

## argocd

Use argocd to deploy argocd.

## argocd-apps

Use argocd-apps to deploy middlewares and applications.

* external-dns
* cert-manager
* ingress-nginx
* prometheus
* grafana
* loki
* tempo
* alertmanager