output "flyway_config_name" {
  value       = kubernetes_config_map.flyway_config.metadata[0].name
  description = "Name of the flyway config path"
}

output "flyway_sql_name" {
  value       = kubernetes_config_map.flyway_sql.metadata[0].name
  description = "Name of the flyway sql path"
}
