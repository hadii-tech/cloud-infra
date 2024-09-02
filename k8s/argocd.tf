resource "kubernetes_namespace" "argo" {
  metadata {
    name = var.argo_ns
  }
}

resource "helm_release" "argocd" {
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.5.1"
  name      = "argocd"
  namespace = var.argo_ns
  values = [
    file("${path.module}/templates/argo-values.yaml")
  ]
}
