output "latest_password" {
    value = data.google_secret_manager_secret_version.secret.secret_data
}