provider "google" {
  project = var.project_id
  region  = var.region
}

module "materialize" {
  source = "../.."

  project_id = var.project_id
  region     = var.region
  prefix     = "mz-simple"

  database_config = {
    tier     = "db-custom-2-4096"
    version  = "POSTGRES_15"
    password = var.database_password
  }

  labels = {
    environment = "simple"
    example     = "true"
  }
}
