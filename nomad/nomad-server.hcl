bind_addr = "0.0.0.0"

# TODO make sure you use your user name
data_dir = "/home/tao/nomad/datadir"

log_level = "INFO"

# TODO make sure you use your user name
log_file  = "/home/tao/nomad/nomad.log"

server {
  enabled = true
  bootstrap_expect = 1
}

# consul {
#   address = "localhost:8500"
# }
