resource "google_compute_network" "vpc" {
  name                    = "${var.prefix}-network"
  auto_create_subnetworks = false
  project                 = var.project_id

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "google_compute_route" "default_route" {
  name             = "${var.prefix}-default-route"
  project          = var.project_id
  network          = google_compute_network.vpc.name
  dest_range       = "0.0.0.0/0"
  priority         = 1000
  next_hop_gateway = "default-internet-gateway"

  # Ensure this is destroyed before the network
  depends_on = [google_compute_network.vpc]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.prefix}-subnet"
  project       = var.project_id
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr
  region        = var.region

  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }
}

resource "google_service_account" "gke_sa" {
  project      = var.project_id
  account_id   = "${var.prefix}-gke-sa"
  display_name = "GKE Service Account for Materialize"
}

resource "google_compute_global_address" "private_ip_address" {
  provider      = google
  project       = var.project_id
  name          = "${var.prefix}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]

  lifecycle {
    create_before_destroy = true
  }

  deletion_policy = "ABANDON"
}

resource "google_service_account" "workload_identity_sa" {
  project      = var.project_id
  account_id   = "${var.prefix}-materialize-sa"
  display_name = "Materialize Workload Identity Service Account"
}

resource "google_container_cluster" "primary" {
  provider = google

  deletion_protection = false

  depends_on = [
    google_service_account.gke_sa,
    google_service_account.workload_identity_sa,
    google_service_networking_connection.private_vpc_connection,
    google_compute_subnetwork.subnet,
    google_compute_route.default_route
  ]

  name     = "${var.prefix}-gke"
  location = var.region
  project  = var.project_id

  networking_mode = "VPC_NATIVE"
  network         = google_compute_network.vpc.name
  subnetwork      = google_compute_subnetwork.subnet.name

  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  release_channel {
    channel = "REGULAR"
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  provider = google

  name     = "${var.prefix}-node-pool"
  location = var.region
  cluster  = google_container_cluster.primary.name
  project  = var.project_id

  node_count = var.node_count

  autoscaling {
    min_node_count = var.min_nodes
    max_node_count = var.max_nodes
  }

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb

    labels = merge(var.labels, {
      "materialize.cloud/disk" = "true"
      "workload"               = "materialize-instance"
    })

    service_account = google_service_account.gke_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  lifecycle {
    create_before_destroy = true

    prevent_destroy = false
  }

}

resource "google_service_account_iam_binding" "workload_identity" {
  depends_on         = [google_service_account.workload_identity_sa]
  service_account_id = google_service_account.workload_identity_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/orchestratord]"
  ]
}
