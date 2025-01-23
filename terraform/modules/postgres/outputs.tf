output "postgres_service_name" {
  value       = kubernetes_service.postgres_service.metadata[0].name
  description = "Name of the PostgreSQL service"
}

output "postgres_pv_name" {
  value       = kubernetes_persistent_volume.postgres_pv.metadata[0].name
  description = "Name of the PostgreSQL Persistent Volume"
}

output "postgres_pvc_name" {
  value       = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
  description = "Name of the PostgreSQL Persistent Volume Claim"
}

output "postgres_service" {
  value = kubernetes_service.postgres_service.metadata[0].name
}

output "postgres_deployment" {
  value = kubernetes_deployment.postgres_deployment.metadata[0].name
}
