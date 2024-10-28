provider "google" {
  project = var.project_id
  region  = var.region
}

module "materialize" {
  source = "../.."

  project_id = var.project_id
  region     = var.region
  prefix     = "mz-${var.environment}"

  network_config = {
    subnet_cidr   = "10.0.0.0/20"
    pods_cidr     = "10.48.0.0/14"
    services_cidr = "10.52.0.0/20"
  }

  gke_config = {
    node_count     = 5
    machine_type   = "e2-standard-8"
    disk_size_gb   = 200
    min_nodes      = 3
    max_nodes      = 7
    node_locations = var.node_locations
  }

  database_config = {
    tier     = "db-custom-8-32768"
    version  = "POSTGRES_15"
    password = var.database_password
  }

  maintenance_window = var.maintenance_window

  labels = {
    environment = var.environment
    team        = var.team
    managed_by  = "terraform"
  }
}
