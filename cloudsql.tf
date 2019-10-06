locals {
  db_name     = "oreno-db"
  db_version = "POSTGRES_9_6"
  db_region = "asia-northeast1"
  db_tier = "db-f1-micro"
}

### CloudSQL
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "cloudsql" {
  name =  "${local.db_name}-${random_id.db_name_suffix.hex}"
  database_version = "${local.db_version}"
  region = "${local.db_region}"

  settings {
    tier = "${local.db_tier}"
    availability_type = "REGIONAL"
    disk_autoresize = true
    backup_configuration {
        enabled = true
    }
  }
}