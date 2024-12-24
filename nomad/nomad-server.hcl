bind_addr = "0.0.0.0"

# TODO make sure you use your user name
data_dir = "/home/d/nomad/datadir"

log_level = "INFO"

# TODO make sure you use your user name
log_file  = "/home/d/nomad/nomad.log"

server {
  enabled = true
  bootstrap_expect = 1
}
