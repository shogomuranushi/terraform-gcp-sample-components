locals {
  pubsub_name     = "oreno-pubsub"
}

### PubSub
resource "google_pubsub_topic" "pubsub" {
  name         = "${local.pubsub_name}"
}