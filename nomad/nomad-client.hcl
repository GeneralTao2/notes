client {
  enabled = true

  host_volume "postgres" {
    # TODO: use your user name here
    path      = "/home/tao/nomad/postgres-data"
    read_only = false
  }

  options {
    "docker.volumes.enabled" = "true"
  }

}