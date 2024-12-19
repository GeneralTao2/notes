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
