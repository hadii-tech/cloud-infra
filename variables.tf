variable "do_token" {}

variable "k8s_cluster_name" {
  description = "Name of cluster to create"
  type        = string
}

variable "tags" {
  description = "Tags to apply to cluster"
  type        = map(string)
  default     = {}
}

variable "top_level_domains" {
  description = "Top level domains to create records and pods for"
  type        = list(string)
}

variable "highly_available" {
  description = "High availability mode"
  type        = bool
}

variable "default_node_pool_size" {
  description = "Default node pool size"
  type        = string
  default     = "s-2vcpu-4gb"
}

variable "do_spaces_secret_key" {
  description = "Digital Ocean secret key for elasticsearch snapshots bucket"
  type        = string
}

variable "do_spaces_access_key" {
  description = "Digital Ocean access key for elasticsearch snapshots bucket"
  type        = string
}

variable "es_snapshots_repo" {
  description = "Name of Elastic Search repository to create for backups"
  type        = string
}
