client {
  enabled = true

#   host_volume "postgres" {
#     path      = "/home/tao/nomad/postgres-data"
#     read_only = false
#   }

  options {
    "docker.volumes.enabled" = "true"
  }

}