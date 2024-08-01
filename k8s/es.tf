
resource "kubernetes_namespace" "elastic" {
  metadata {
    name = var.elastic_ns
  }
}

data "http" "synonyms" {
  url = "https://raw.githubusercontent.com/rewayaat/rewayaat/master/src/main/resources/synonyms.txt"
}

resource "kubernetes_config_map" "elastic-cm" {
  metadata {
    name      = "elastic-cm"
    namespace = var.elastic_ns
  }
  data = {
    "synonyms.txt"       = data.http.synonyms.body
    "create_repo.json"   = "${file("${path.module}/templates/create_repo.json")}"
    "snapshot-script.sh" = "${file("${path.module}/templates/snapshot-script.sh")}"
  }
  depends_on = [kubernetes_namespace.elastic]
}


resource "kubernetes_secret" "elastic-secrets" {
  metadata {
    name      = "elastic-secrets"
    namespace = var.elastic_ns
  }
  immutable = true
  data = {
    DO_ACCESS_KEY_ID     = var.do_spaces_access_key
    DO_SECRET_ACCESS_KEY = var.do_spaces_secret_key

  }
  depends_on = [kubernetes_namespace.elastic]
}

resource "helm_release" "elasticsearch" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "elasticsearch"
  name       = "elasticsearch"
  version    = "18.2.6"
  namespace  = var.elastic_ns
  values = [
    "${file("${path.module}/templates/es-values.yml")}"
  ]
  depends_on = [time_sleep.kube_create_wait, kubernetes_secret.elastic-secrets]
}

resource "kubernetes_cron_job_v1" "es-snapshot" {
  metadata {
    name      = "es-snapshot"
    namespace = var.elastic_ns
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 3
    schedule                      = "@midnight"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 3
    job_template {
      metadata {}
      spec {
        backoff_limit              = 2
        parallelism                = 1
        ttl_seconds_after_finished = 604800
        template {
          metadata {}
          spec {
            container {
              name  = "es-snapshot"
              image = "curlimages/curl"
              command = [
                "/bin/sh",
                "-c",
                "/opt/bitnami/elasticsearch/config/snapshot-script.sh"
              ]
              env {
                name  = "ES_SNAPSHOTS_REPO"
                value = var.es_snapshots_repo
              }
              volume_mount {
                mount_path = "/opt/bitnami/elasticsearch/config/create_repo.json"
                name       = "elastic-cm"
                sub_path   = "create_repo.json"
              }
              volume_mount {
                mount_path = "/opt/bitnami/elasticsearch/config/snapshot-script.sh"
                name       = "elastic-cm"
                sub_path   = "snapshot-script.sh"
              }
            }
            volume {
              name = "elastic-cm"
              config_map {
                name         = "elastic-cm"
                default_mode = "0777"
              }
            }
          }
        }
      }
    }
  }
  depends_on = [helm_release.elasticsearch]
}
