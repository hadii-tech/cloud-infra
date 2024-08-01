k8s_cluster_name = "hadii-k8s"

tags = {
  "repo" : "infra/do"
}

top_level_domains = [
  "striffs.io",
  "rewayaat.info",
  "es.rewayaat.info"
]

highly_available = true

default_node_pool_size = "s-4vcpu-8gb"

es_snapshots_repo = "es-backups"