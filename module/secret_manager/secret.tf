# Define secret
resource "google_secret_manager_secret" "db_password" {
    secret_id = "petclinic-db-password"
    replication {
        user_managed {
            replicas {
                location = "us-central1"
            }
        }
    }
}
# Read password file  
data "local_file" "db_password" {
    filename = "./db_pass.txt"
}


# Create secret version with file content
resource "google_secret_manager_secret_version" "latest" {
    secret = google_secret_manager_secret.db_password.id
    secret_data = data.local_file.db_password.content
}

#Get latest version data
data "google_secret_manager_secret_version" "get-latest" {
    secret = google_secret_manager_secret.db_password.id

    depends_on = [
        google_secret_manager_secret_version.latest
    ]
}

# Lookup secret value
data "google_secret_manager_secret_version" "secret" {
    secret = google_secret_manager_secret.db_password.id
    version = data.google_secret_manager_secret_version.get-latest.version
}