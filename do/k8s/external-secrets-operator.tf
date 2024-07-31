resource "helm_release" "external-secrets" {
  repository       = "https://charts.external-secrets.io"
  version          = "0.9.13"
  chart            = "external-secrets"
  name             = "external-secrets"
  create_namespace = true
  depends_on       = [time_sleep.kube_create_wait]
  set {
    name  = "installCRDs"
    value = "true"
  }
}
