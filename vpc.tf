locals {
  vpc_region = "asia-northeast1"
}

resource "google_compute_network" "main" {
  name = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "vpc-subnetwork-main"
  ip_cidr_range = "10.2.0.0/16"
  region        = "${local.vpc_region}"
  network       = "${google_compute_network.main.self_link}"
}