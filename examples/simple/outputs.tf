output "gke_cluster" {
  description = "GKE cluster details"
  value       = module.materialize.gke_cluster
  sensitive   = true
}

output "database" {
  description = "Cloud SQL instance details"
  value       = module.materialize.database
  sensitive   = true
}

output "storage" {
  description = "GCS bucket details"
  value       = module.materialize.storage
}

output "service_accounts" {
  description = "Service account details"
  value       = module.materialize.service_accounts
}
