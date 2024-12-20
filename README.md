<!-- BEGIN_TF_DOCS -->
# Materialize on Google Cloud Platform

Terraform module for deploying Materialize on Google Cloud Platform (GCP) with all required infrastructure components.

This module sets up:
- GKE cluster for Materialize workloads
- Cloud SQL PostgreSQL instance for metadata storage
- Cloud Storage bucket for persistence
- Required networking and security configurations
- Service accounts with proper IAM permissions

> **Warning** This is provided on a best-effort basis and Materialize cannot offer support for this module.

The module has been tested with:
- GKE version 1.28
- PostgreSQL 15
- Materialize Operator v0.1.0

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_database"></a> [database](#module\_database) | ./modules/database | n/a |
| <a name="module_gke"></a> [gke](#module\_gke) | ./modules/gke | n/a |
| <a name="module_storage"></a> [storage](#module\_storage) | ./modules/storage | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_config"></a> [database\_config](#input\_database\_config) | Cloud SQL configuration | <pre>object({<br/>    tier     = optional(string, "db-custom-2-4096")<br/>    version  = optional(string, "POSTGRES_15")<br/>    password = string<br/>    username = optional(string, "materialize")<br/>    db_name  = optional(string, "materialize")<br/>  })</pre> | n/a | yes |
| <a name="input_gke_config"></a> [gke\_config](#input\_gke\_config) | GKE cluster configuration | <pre>object({<br/>    node_count     = number<br/>    machine_type   = string<br/>    disk_size_gb   = number<br/>    min_nodes      = number<br/>    max_nodes      = number<br/>    node_locations = list(string)<br/>  })</pre> | <pre>{<br/>  "disk_size_gb": 50,<br/>  "machine_type": "e2-standard-4",<br/>  "max_nodes": 2,<br/>  "min_nodes": 1,<br/>  "node_count": 1,<br/>  "node_locations": []<br/>}</pre> | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for Materialize | `string` | `"materialize"` | no |
| <a name="input_network_config"></a> [network\_config](#input\_network\_config) | Network configuration for the GKE cluster | <pre>object({<br/>    subnet_cidr   = string<br/>    pods_cidr     = string<br/>    services_cidr = string<br/>  })</pre> | <pre>{<br/>  "pods_cidr": "10.48.0.0/14",<br/>  "services_cidr": "10.52.0.0/20",<br/>  "subnet_cidr": "10.0.0.0/20"<br/>}</pre> | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix to be used for resource names | `string` | `"materialize"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project where resources will be created | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where resources will be created | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_strings"></a> [connection\_strings](#output\_connection\_strings) | Formatted connection strings for Materialize |
| <a name="output_database"></a> [database](#output\_database) | Cloud SQL instance details |
| <a name="output_gke_cluster"></a> [gke\_cluster](#output\_gke\_cluster) | GKE cluster details |
| <a name="output_service_accounts"></a> [service\_accounts](#output\_service\_accounts) | Service account details |
| <a name="output_storage"></a> [storage](#output\_storage) | GCS bucket details |
<!-- END_TF_DOCS -->
