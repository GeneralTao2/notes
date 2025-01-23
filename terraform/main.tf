terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

module "postgres" {
  source            = "./modules/postgres"
  postgres_user     = var.postgres_user
  postgres_password = var.postgres_password
  postgres_db       = var.postgres_db
}

module "configmap" {
  source            = "./modules/configmap"

  depends_on = [module.postgres]
}

module "flyway" {
  source            = "./modules/flyway"
  namespace         = "default"
  postgres_address  = module.postgres.postgres_service
  postgres_port     = 5432
  postgres_user     = var.postgres_user
  postgres_password = var.postgres_password
  postgres_db       = var.postgres_db

  depends_on = [module.postgres, module.configmap]
}

module "notes" {
  source           = "./modules/notes"
  app_image        = var.app_image
  postgres_address = var.postgres_address
  postgres_port    = var.postgres_port
  postgres_user    = var.postgres_user
  postgres_password = var.postgres_password
  postgres_db      = var.postgres_db
  host_log_path    = var.host_log_path
}
