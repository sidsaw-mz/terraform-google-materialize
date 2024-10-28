# Complete Materialize on GCP Example

This example demonstrates a production-ready deployment of Materialize on Google Cloud Platform with all features enabled.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan \
  -var project_id="your-project-id" \
  -var database_password="your-secure-password"
$ terraform apply \
  -var project_id="your-project-id" \
  -var database_password="your-secure-password"
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Features Demonstrated

- Custom VPC network configuration
- High-availability GKE cluster setup
- Production-grade Cloud SQL instance
- Workload identity configuration
- Custom node pool configuration
- Resource labeling
- Backup configuration

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| google | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 6.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | GCP Project ID | string | n/a | yes |
| region | GCP Region | string | "us-central1" | no |
| database_password | Password for Cloud SQL database user | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gke_cluster | GKE cluster details |
| database | Cloud SQL instance details |
| storage | GCS bucket details |
