variable "namespace" {
  default     = "NotesSpace"
}

variable "postgres_address" {}

variable "postgres_port" {}

variable "postgres_user" {}

variable "postgres_password" {}

variable "postgres_db" {}

variable "app_image" {
  default     = "notes:0.1.0-SNAPSHOT"
}

variable "host_log_path" {
  default     = "/mnt/c/intbench/notes/logs"
}
