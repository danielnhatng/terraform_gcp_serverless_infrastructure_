resource "google_sql_database_instance" "petclinic-sql-instance" {
    name                = "petclinic-sql-instance"
    region              = "us-central1"
    deletion_protection = false
    database_version    = "MYSQL_8_0"
    
    settings {
    tier              = "db-n1-standard-1"
    availability_type = "REGIONAL"
    disk_size = 20
    disk_type = "PD_SSD"
    backup_configuration {
        binary_log_enabled = true
        enabled            = true
    }
    ip_configuration {
        ipv4_enabled    = false
        private_network = var.network
    }
}
}

resource "google_sql_database" "petclinic-database" {
    name      = "petclinic_db"
    instance  = google_sql_database_instance.petclinic-sql-instance.name
    charset   = "utf8"
    collation = "utf8_general_ci"
}

resource "google_sql_user" "users" {
    name     = "root"
    instance = google_sql_database_instance.petclinic-sql-instance.name
    password = var.latest_db_pass
    host     = "%"

}