
resource "kubernetes_namespace" "mongo" {
  metadata {
    name = var.mongo_ns
  }
}

resource "helm_release" "mongodb" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  name       = "mongodb"
  version    = "15.6.18"
  namespace  = var.mongo_ns
  values = [
    "${file("${path.module}/templates/mongo-values.yml")}"
  ]
  depends_on = [time_sleep.kube_create_wait, kubernetes_namespace.mongo]
}
