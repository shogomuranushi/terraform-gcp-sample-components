locals {
  dns_zone     = "api-oreno-com"
  dns_domain     = "oreno.com."
}

### DNS
resource "google_project_service" "dns" {
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_dns_managed_zone" "zone" {
  name = "${local.dns_zone}"
  dns_name = "${local.dns_domain}"
}

output "zone" {
  value = "${google_dns_managed_zone.zone.name_servers}"
}

output "zone-name" {
  value = "${google_dns_managed_zone.zone.name}"
}


resource "google_dns_record_set" "api" {
  name = "api.${google_dns_managed_zone.zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.zone.name}"

  rrdatas = ["8.8.8.8"]
}