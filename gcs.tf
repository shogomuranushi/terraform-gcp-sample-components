locals {
  gcs_name     = "oreno-gcs"
  gcs_location = "asia-northeast1"
}

### GCS
resource "google_project_service" "gcs" {
  service            = "storage-component.googleapis.com"
  disable_on_destroy = false
}

resource "google_storage_bucket" "gcs" {
  name          = "${local.gcs_name}"
  location      = "${local.gcs_location}"
  storage_class = "REGIONAL"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 5
    }
  }

  encryption {
    default_kms_key_name = "${google_kms_crypto_key.gcs.self_link}"
  }
}

### KMS
resource "google_kms_crypto_key" "gcs" {
  name            = "gcs"
  key_ring        = "${google_kms_key_ring.gcs.self_link}"
  rotation_period = "86401s"
}

resource "google_kms_key_ring" "gcs" {
  name     = "gcs"
  location = "${local.gcs_location}"
}