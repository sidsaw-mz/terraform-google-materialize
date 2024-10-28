output "gke_cluster" {
  description = "GKE cluster details"
  value = {
    name     = module.gke.cluster_name
    endpoint = module.gke.cluster_endpoint
    location = module.gke.cluster_location
  }
  sensitive = true
}

output "database" {
  description = "Cloud SQL instance details"
  value = {
    name           = module.database.instance_name
    connection_url = module.database.connection_url
    private_ip     = module.database.private_ip
  }
  sensitive = true
}

output "storage" {
  description = "GCS bucket details"
  value = {
    name      = module.storage.bucket_name
    url       = module.storage.bucket_url
    self_link = module.storage.bucket_self_link
  }
}

output "service_accounts" {
  description = "Service account details"
  value = {
    gke_sa         = module.gke.service_account_email
    materialize_sa = module.gke.workload_identity_sa_email
  }
}
