output "cloud_sql_instance" {
    value = google_sql_database_instance.petclinic-sql-instance.connection_name
}