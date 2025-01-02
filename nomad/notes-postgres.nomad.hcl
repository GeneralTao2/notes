job "notes-postgres" {
  type = "service"

  group "notes-postgres-group" {
    count = 1

    volume "postgres" {
      type      = "host"
      read_only = false
      source    = "postgres"
    }

    network {
      port "postgres" {
        static = 5432
      }
    }

    service {
      name     = "notes-postgres-svc"
      port     = "postgres"
      provider = "nomad"
    }

    task "postgres-task" {

      volume_mount {
        volume      = "postgres"
        destination = "/var/lib/postgresql/data"
        read_only   = false
      }

      template {
        data        = <<EOH
POSTGRES_USER=d
POSTGRES_PASSWORD=d
EOH
        destination = "local/env.txt"
        env         = true
      }

      driver = "docker"

      config {
        image = "postgres:16"
        ports = ["postgres"]
      }
    }
  }
}