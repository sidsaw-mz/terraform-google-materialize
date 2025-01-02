variable "region" {
  description = "GCP region"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "environmentd_version" {
  description = "Version of the Materialize environmentd image"
  type        = string
  default     = "v0.127.1"
}

variable "operator_version" {
  description = "Version of the Materialize operator"
  type        = string
  default     = "v25.1.0-beta.1"
}

variable "operator_namespace" {
  description = "Namespace for the Materialize operator"
  type        = string
  default     = "materialize"
}

variable "storage_bucket_name" {
  description = "Name of the GCS bucket for Materialize storage"
  type        = string
}

variable "workload_identity_sa_email" {
  description = "Email of the GCP service account for workload identity"
  type        = string
}

variable "hmac_access_id" {
  description = "HMAC access ID for GCS bucket access"
  type        = string
}

variable "hmac_secret" {
  description = "HMAC secret for GCS bucket access"
  type        = string
  sensitive   = true
}

variable "instances" {
  description = "Configuration for Materialize instances"
  type = list(object({
    name              = string
    namespace         = optional(string, "materialize-environment")
    database_name     = string
    database_username = string
    database_password = string
    database_host     = string
    cpu_request       = optional(string, "1")
    memory_request    = optional(string, "1Gi")
    memory_limit      = optional(string, "1Gi")
  }))
  default = []
}

variable "postgres_version" {
  description = "Postgres version to use for the metadata backend"
  type        = string
  default     = "15"
}
