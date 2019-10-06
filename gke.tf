locals {
  k8s_version        = "1.13.7-gke.24"
  k8s_location       = "asia-northeast1"
  k8s_name           = "oreno-gke"
  initial_node_count = 3
  min_node_count     = 3
  max_node_count     = 6
  machine_type       = "n1-standard-2"

}

### GKE
resource "google_project_service" "gke" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_container_cluster" "primary" {
  name     = "${local.k8s_name}"
  location = "${local.k8s_location}"

  remove_default_node_pool = true
  initial_node_count       = 1
  min_master_version       = "${local.k8s_version}"
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name     = "${local.k8s_name}-preemptible-node-pool"
  location = "${local.k8s_location}"
  cluster  = "${google_container_cluster.primary.name}"

  management {
    auto_repair = true
  }

  initial_node_count = "${local.initial_node_count}"
  autoscaling {
    min_node_count = "${local.min_node_count}"
    max_node_count = "${local.max_node_count}"
  }

  node_config {
    preemptible  = true
    machine_type = "${local.machine_type}"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }
}