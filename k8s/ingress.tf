resource "digitalocean_loadbalancer" "ingress_load_balancer" {
  name      = "${var.cluster_name}-lb"
  region    = var.region
  size      = "lb-small"
  algorithm = "round_robin"
  forwarding_rule {
    entry_port      = 80
    entry_protocol  = "http"
    target_port     = 80
    target_protocol = "http"
  }
  lifecycle {
    ignore_changes = [
      forwarding_rule,
    ]
  }
  depends_on = [time_sleep.kube_create_wait]
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  namespace        = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true
  timeout          = 600
  set {
    name  = "service.annotations.kubernetes\\.digitalocean\\.com/load-balancer-id"
    value = digitalocean_loadbalancer.ingress_load_balancer.id
  }
  set {
    name  = "controller.watchIngressWithoutClass"
    value = true
  }
  values = [
    "${file("${path.module}/templates/ingress-values.yml")}"
  ]
  depends_on = [
    digitalocean_loadbalancer.ingress_load_balancer
  ]
}

resource "kubernetes_manifest" "monitoring-ingresses" {
  manifest = yamldecode(file("${path.module}/templates/MonitoringIngress.yaml"))
  depends_on = [
    helm_release.ingress-nginx,
    helm_release.kube-prometheus-stack
  ]
}

resource "kubernetes_manifest" "argo-ingresses" {
  manifest = yamldecode(file("${path.module}/templates/ArgoIngress.yaml"))
  depends_on = [
    helm_release.argocd
  ]
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.7.0"
  namespace        = "cert-manager"
  create_namespace = true
  timeout          = 120
  depends_on = [
    helm_release.ingress-nginx,
  ]
  set {
    name  = "createCustomResource"
    value = "true"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
  set {
    name  = "ingressShim.defaultIssuerName"
    value = "letsencrypt-prod"
  }
  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }
}

resource "kubernetes_manifest" "cluster-issuer" {
  manifest = yamldecode(file("${path.module}/templates/ClusterIssuer.yaml"))
  depends_on = [
    helm_release.cert-manager
  ]
}