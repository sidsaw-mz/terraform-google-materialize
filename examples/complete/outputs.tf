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

output "network_details" {
  description = "VPC network details"
  value = {
    network_name = module.materialize.gke_cluster.network_name
    subnet_name  = module.materialize.gke_cluster.subnet_name
  }
}

output "database_connection_helper" {
  description = "Helper script to connect to the database using Cloud SQL Proxy"
  value       = <<EOF
# Install Cloud SQL Proxy
curl -o cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.6.1/cloud-sql-proxy.linux.amd64
chmod +x cloud-sql-proxy

# Start the proxy
./cloud-sql-proxy ${module.materialize.database.instance_name} &

# Connect to the database
psql "${module.materialize.database.connection_url}"
EOF
}

output "helm_values_helper" {
  description = "Sample Helm values for Materialize configuration"
  value       = <<EOF
environment:
  secret:
    metadataBackendUrl: ${module.materialize.database.connection_url}
    persistBackendUrl: gs://${module.materialize.storage.bucket_name}

operator:
  args:
    cloudProvider: "gcp"
    region: "${var.region}"
    localDevelopment: false
EOF
}
