resource "helm_release" "kube-state-metrics" {
  name             = "kube-state-metrics"
  chart            = "kube-state-metrics"
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "5.18.1"
  namespace        = "monitoring"
  create_namespace = true
  depends_on       = [time_sleep.kube_create_wait]
}

resource "helm_release" "kube-prometheus-stack" {
  name             = "kube-prometheus-stack"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = "55.7.0"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    "${file("${path.module}/templates/monitoring-values.yml")}"
  ]
  depends_on = [helm_release.kube-state-metrics]
}
