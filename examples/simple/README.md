# Simple Materialize on GCP Example

This example demonstrates a basic deployment of Materialize on Google Cloud Platform using the minimum required configuration.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan -var project_id="your-project-id" -var database_password="your-secure-password"
$ terraform apply -var project_id="your-project-id" -var database_password="your-secure-password"
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

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
