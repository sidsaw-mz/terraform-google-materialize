resource "google_sql_database_instance" "materialize" {
  name             = "${var.prefix}-pg"
  database_version = var.db_version
  region           = var.region
  project          = var.project_id

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      backup_retention_settings {
        retained_backups = 7
      }
    }

    maintenance_window {
      day          = 7 # Sunday
      hour         = 3 # 3 AM
      update_track = "stable"
    }
  }

  deletion_protection = true
}

resource "google_sql_database" "materialize" {
  name     = "materialize_db"
  instance = google_sql_database_instance.materialize.name
  project  = var.project_id
}

resource "google_sql_user" "materialize" {
  name     = "materialize_user"
  instance = google_sql_database_instance.materialize.name
  password = var.password
  project  = var.project_id
}
