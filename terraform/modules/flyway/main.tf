resource "kubernetes_job" "flyway_migration_job" {
  metadata {
    name      = "flyway-migration-job"
    namespace = var.namespace
  }

  spec {
    template {
      metadata {
        labels = {
          app = "flyway"
        }
      }

      spec {
        container {
          name  = "flyway"
          image = "flyway/flyway:7.10"
          image_pull_policy = "Always"

          args = [
            "migrate",
            "-configFiles=/flyway/flyway.conf"
          ]

          env {
            name  = "POSTGRES_ADDRESS"
            value = var.postgres_address
          }

          env {
            name  = "POSTGRES_PORT"
            value = var.postgres_port
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
            name       = "flyway-config"
            mount_path = "/flyway/flyway.conf"
            sub_path   = "flyway.conf"
          }

          volume_mount {
            name       = "flyway-sql"
            mount_path = "/flyway/sql"
          }
        }

        restart_policy = "Never"

        volume {
          name = "flyway-config"
          config_map {
            name = "flyway-config"
          }
        }

        volume {
          name = "flyway-sql"
          config_map {
            name = "flyway-sql"
          }
        }
      }
    }
  }
}
