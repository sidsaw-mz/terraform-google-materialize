variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "database_password" {
  description = "Password for Cloud SQL database user"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (e.g., prod, staging)"
  type        = string
  default     = "prod"
}

variable "team" {
  description = "Team name for resource labeling"
  type        = string
  default     = "data-platform"
}

variable "node_locations" {
  description = "List of zones for node pool"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "maintenance_window" {
  description = "Maintenance window for GKE cluster"
  type = object({
    day          = string
    hour         = number
    update_track = string
  })
  default = {
    day          = "SUNDAY"
    hour         = 2
    update_track = "stable"
  }
}
