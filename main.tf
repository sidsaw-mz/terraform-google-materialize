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

  depends_on = [module.gke]

  database_name = var.database_config.db_name
  database_user = var.database_config.username

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

module "operator" {
  source = "./modules/operator"
  count  = var.install_materialize_operator ? 1 : 0

  depends_on = [
    module.gke,
    module.database,
    module.storage
  ]

  region                     = var.region
  prefix                     = var.prefix
  operator_namespace         = var.namespace
  storage_bucket_name        = module.storage.bucket_name
  workload_identity_sa_email = module.gke.workload_identity_sa_email
  hmac_access_id             = module.storage.hmac_access_id
  hmac_secret                = module.storage.hmac_secret
  operator_version           = var.operator_version
  environmentd_version       = var.environmentd_version

  instances = var.materialize_instances != null ? [
    for instance in var.materialize_instances : {
      name              = instance.name
      namespace         = instance.namespace
      database_name     = instance.database_name
      database_username = var.database_config.username
      database_password = var.database_config.password
      database_host     = module.database.private_ip
      cpu_request       = instance.cpu_request
      memory_request    = instance.memory_request
      memory_limit      = instance.memory_limit
    }
  ] : []

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}
