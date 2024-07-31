output "kubernetes_id" {
  description = "ID of the cluster"
  value       = digitalocean_kubernetes_cluster.default_cluster.id
}
output "kubernetes_host" {
  description = "The hostname of the API server for the cluster"
  value       = digitalocean_kubernetes_cluster.default_cluster.endpoint
}

output "kubernetes_urn" {
  description = "The uniform resource name (URN) for the Kubernetes cluster."
  value       = digitalocean_kubernetes_cluster.default_cluster.urn
}

output "kubernetes_created" {
  description = "Created at timestamp for the cluster"
  value       = digitalocean_kubernetes_cluster.default_cluster.created_at
}

output "kubeconfig" {
  value = digitalocean_kubernetes_cluster.default_cluster.kube_config[0].raw_config
}