job "notes-flyway" {
  type = "batch"

  group "notes-flyway-group" {
    count = 1
    restart {
      attempts = 0
    }

    task "notes-flyway-task" {

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
        image = "flyway/flyway:10.18.0"
        command = "migrate"
        volumes = [
          # TODO make sure you use your path to project
          "/mnt/c/Users/ADiulgher/Documents/Intellij/notes/flyway/flyway.conf:/flyway/conf/flyway.conf",
          "/mnt/c/Users/ADiulgher/Documents/Intellij/notes/flyway/sql:/flyway/sql"
        ]
      }
    }
  }
}