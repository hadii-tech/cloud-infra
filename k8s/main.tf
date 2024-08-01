terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.8.0"
    }
  }
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.default_cluster.endpoint
  token = digitalocean_kubernetes_cluster.default_cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.default_cluster.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.default_cluster.endpoint
    token = digitalocean_kubernetes_cluster.default_cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.default_cluster.kube_config[0].cluster_ca_certificate
    )
  }
}

# Run 
#provider "kubernetes" {
#  config_path = "/home/mfadhel/.kube/config"
#}

#provider "helm" {
#  kubernetes {
#    config_path = "/home/mfadhel/.kube/config"
#  }
#}

resource "digitalocean_kubernetes_cluster" "default_cluster" {
  name     = var.cluster_name
  region   = var.region
  version  = "1.29.1-do.0"
  vpc_uuid = var.vpc_id
  ha       = var.highly_available
  node_pool {
    name       = "${var.cluster_name}-default-pool"
    size       = var.default_node_pool_size
    auto_scale = true
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
  }
}

resource "time_sleep" "kube_create_wait" {
  depends_on      = [digitalocean_kubernetes_cluster.default_cluster]
  create_duration = "300s"
}
