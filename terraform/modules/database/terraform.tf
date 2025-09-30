resource "google_sql_database_instance" "postgres_db" {
  name             = "cp-cloud-sql-bm"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "petclinic_db" {
  name     = "petclinic"
  instance = google_sql_database_instance.postgres_db.name
}

resource "google_sql_user" "db_user" {
  name = var.db_username
  password = var.db_password
  instance = google_sql_database_instance.postgres_db.name
}



output "db_ip" {
  value = google_sql_database_instance.postgres_db.public_ip_address
}