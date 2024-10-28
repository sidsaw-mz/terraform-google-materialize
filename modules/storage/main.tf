resource "google_storage_bucket" "materialize" {
  name          = "${var.prefix}-storage-${var.project_id}"
  location      = var.region
  project       = var.project_id
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  labels = var.labels
}

resource "google_storage_bucket_iam_member" "materialize_storage" {
  bucket = google_storage_bucket.materialize.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${var.service_account}"
}
