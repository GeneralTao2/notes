resource "kubernetes_deployment" "notes_app" {
  metadata {
    name      = "notes-deployment"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "notes-image"
      }
    }

    template {
      metadata {
        labels = {
          app = "notes-image"
        }
      }

      spec {
        container {
          name  = "notes-image"
          image = var.app_image

          env {
            name  = "POSTGRES_ADDRESS"
            value = var.postgres_address
          }

          env {
            name  = "POSTGRES_PORT"
            value = tostring(var.postgres_port)
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

          port {
            container_port = 8080
          }

          volume_mount {
            name       = "log-storage"
            mount_path = "/logs"
          }
        }

        container {
          name  = "log-writer-sidecar"
          image = "busybox"
          command = [
            "sh",
            "-c",
            "tail -F /logs/application.log > /mnt/log/application.log"
          ]

          volume_mount {
            name       = "log-storage"
            mount_path = "/logs"
          }

          volume_mount {
            name       = "host-log-storage"
            mount_path = "/mnt/log"
          }
        }

        volume {
          name = "log-storage"
          empty_dir {}
        }

        volume {
          name = "host-log-storage"
          host_path {
            path = var.host_log_path
            type = "Directory"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "notes_service" {
  metadata {
    name      = "notes-service"
    namespace = "default"
    labels = {
      app = "notes-image"
    }
  }

  spec {
    selector = {
      app = "notes-image"
    }

    port {
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
      node_port    = 8080
    }

    type = "NodePort"
  }
}
