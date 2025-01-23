resource "kubernetes_persistent_volume" "postgres_pv" {
  metadata {
    name = "postgres-pv"
  }

  spec {
    capacity = {
      storage = "1Gi"
    }

    volume_mode       = "Filesystem"
    storage_class_name = "standard"
    access_modes      = ["ReadWriteOnce"]

    persistent_volume_source {
      host_path {
        path = "/data"
        type = "DirectoryOrCreate"
      }
    }
  }
  lifecycle {
    ignore_changes = [metadata]
  }
}


resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name = "postgres-pvc"
  }

  spec {
    volume_name       = kubernetes_persistent_volume.postgres_pv.metadata[0].name
    storage_class_name = "standard"
    access_modes      = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_service" "postgres_service" {
  metadata {
    name = "postgres-service"
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      protocol    = "TCP"
      port        = 5432
      target_port = 5432
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_deployment" "postgres_deployment" {
  metadata {
    name = "postgres-deployment"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:16.6"

          port {
            container_port = 5432
          }

          env {
            name  = "POSTGRES_USER"
            value = var.postgres_user
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }

          env {
            name  = "POSTGRES_DB"
            value = var.postgres_db
          }

          volume_mount {
            name       = "postgres-data"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "postgres-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }
      }
    }
  }
}
