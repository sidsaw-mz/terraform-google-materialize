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
