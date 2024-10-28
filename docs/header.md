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
