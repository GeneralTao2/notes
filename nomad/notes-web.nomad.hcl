job "notes-web-job" {
  type = "service"

  group "notes-web-group" {
    count = 1
    network {
      port "web" {
        static = 8080
      }
    }

    service {
      name     = "notes-web-svc"
      port     = "web"
      provider = "nomad"
    }

    task "notes-web-task" {

      template {
        data        = <<EOH
{{ range nomadService "notes-postgres-svc" }}
POSTGRES_ADDRESS={{ .Address }}
POSTGRES_PORT={{ .Port }}
POSTGRES_USER=d
POSTGRES_PASSWORD=d
POSTGRES_DB=postgres
{{ end }}
EOH
        destination = "local/env.txt"
        env         = true
      }

      driver = "docker"

      config {
        image = "notes:0.0.1-SNAPSHOT"
        ports = ["web"]
      }

      # configured because of error
      # fixed memory regions require 589466K which is greater than 300M
      resources {
        memory = 700
      }
    }
  }
}
