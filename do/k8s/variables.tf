variable "cluster_name" {
  description = "Name of cluster to create"
  type        = string
}

variable "region" {
  description = "region to build cluster in"
  type        = string
  default     = "tor1"
}

variable "default_node_pool_size" {
  description = "Default node pool size"
  type        = string
}

variable "min_nodes" {
  description = "min number of nodes"
  type        = number
  default     = 1
}

variable "highly_available" {
  description = "High availability mode"
  type        = bool
  default     = false
}

variable "max_nodes" {
  description = "max number of nodes"
  type        = number
  default     = 3
}

variable "vpc_id" {
  description = "VPC ID to deploy kube cluster"
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

variable "elastic_ns" {
  type    = string
  default = "elastic"
}

