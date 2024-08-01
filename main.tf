resource "digitalocean_vpc" "main_vpc" {
  name     = "main-vpc"
  region   = "tor1"
  ip_range = "10.0.0.0/20"
}

module "k8s" {
  source                 = "./k8s"
  cluster_name           = var.k8s_cluster_name
  vpc_id                 = digitalocean_vpc.main_vpc.id
  tags                   = var.tags
  top_level_domains      = var.top_level_domains
  default_node_pool_size = var.default_node_pool_size
  do_spaces_secret_key   = var.do_spaces_secret_key
  do_spaces_access_key   = var.do_spaces_access_key
  es_snapshots_repo      = var.es_snapshots_repo
  highly_available       = var.highly_available
}
