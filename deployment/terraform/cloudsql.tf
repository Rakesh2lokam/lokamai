resource "google_sql_database_instance" "staging" {
  name             = "lokamai-staging-db"
  database_version = "POSTGRES_17"
  region           = var.region
  project          = var.staging_project_id

  settings {
    tier = "db-perf-optimized-N-2"
    ip_configuration {
      # For public IP, allow all (not recommended for prod)
      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0"
      }
    }
  }
}

resource "google_sql_database" "staging" {
  name     = "lokamai"
  instance = google_sql_database_instance.staging.name
  project  = var.staging_project_id
}

resource "google_sql_user" "staging" {
  name     = "lokamaiuser"
  instance = google_sql_database_instance.staging.name
  password = "lokamaiuser" # Use a secret in production!
  project  = var.staging_project_id
}