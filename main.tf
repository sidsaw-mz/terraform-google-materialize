locals {
  common_labels = merge(var.labels, {
    managed_by = "terraform"
    module     = "materialize"
  })
}

module "gke" {
  source = "./modules/gke"

  project_id    = var.project_id
  region        = var.region
  prefix        = var.prefix
  subnet_cidr   = var.network_config.subnet_cidr
  pods_cidr     = var.network_config.pods_cidr
  services_cidr = var.network_config.services_cidr

  node_count   = var.gke_config.node_count
  machine_type = var.gke_config.machine_type
  disk_size_gb = var.gke_config.disk_size_gb
  min_nodes    = var.gke_config.min_nodes
  max_nodes    = var.gke_config.max_nodes

  namespace = var.namespace
  labels    = local.common_labels
}

module "database" {
  source = "./modules/database"

  project_id = var.project_id
  region     = var.region
  prefix     = var.prefix
  network_id = module.gke.network_id

  tier       = var.database_config.tier
  db_version = var.database_config.version
  password   = var.database_config.password

  labels = local.common_labels
}

module "storage" {
  source = "./modules/storage"

  project_id      = var.project_id
  region          = var.region
  prefix          = var.prefix
  service_account = module.gke.workload_identity_sa_email

  labels = local.common_labels
}
