variable "project_id" {
  description = "The ID of the project where resources will be created"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  type        = string
  default     = "us-central1"
}

variable "prefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = "materialize"
}

variable "network_config" {
  description = "Network configuration for the GKE cluster"
  type = object({
    subnet_cidr   = string
    pods_cidr     = string
    services_cidr = string
  })
  default = {
    subnet_cidr   = "10.0.0.0/20"
    pods_cidr     = "10.48.0.0/14"
    services_cidr = "10.52.0.0/20"
  }
}

variable "gke_config" {
  description = "GKE cluster configuration"
  type = object({
    node_count     = number
    machine_type   = string
    disk_size_gb   = number
    min_nodes      = number
    max_nodes      = number
    node_locations = list(string)
  })
  default = {
    node_count     = 3
    machine_type   = "e2-standard-4"
    disk_size_gb   = 100
    min_nodes      = 1
    max_nodes      = 5
    node_locations = []
  }
}

variable "database_config" {
  description = "Cloud SQL configuration"
  type = object({
    tier     = string
    version  = string
    password = string
  })
  default = {
    tier     = "db-custom-2-4096"
    version  = "POSTGRES_15"
    password = null # Must be provided
  }
  validation {
    condition     = var.database_config.password != null
    error_message = "database_config.password must be provided"
  }
}

variable "namespace" {
  description = "Kubernetes namespace for Materialize"
  type        = string
  default     = "materialize"
}

variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default     = {}
}
