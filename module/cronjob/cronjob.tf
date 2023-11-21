resource "google_cloud_scheduler_job" "stop_cloudrun_scheduler" {
    name        = "stop-cloudsql-scheduler"
    description = "Scheduler job to stop a Cloud Run service"

    schedule = "0 11 * * *"  # 11 UTC = 18 VietNam time
    region = "us-central1"
    http_target {
        uri = "https://www.googleapis.com/sql/v1beta4/projects/learning-cloud-with-fpt/instances/petclinic-sql-instance"
        http_method = "PATCH"
        body = base64encode(jsonencode({
            settings = {
                activationPolicy = "NEVER"
            }
        }))
        oauth_token {
            service_account_email = "sql-admin@learning-cloud-with-fpt.iam.gserviceaccount.com"
            scope = "https://www.googleapis.com/auth/cloud-platform"
        }
    }
}

resource "google_cloud_scheduler_job" "start_cloudsql_scheduler" {
    name        = "start-cloudsql-scheduler"
    description = "Scheduler job to start a Cloud SQL instance"

    schedule = "0 0 * * *"  # 12AM UTC = 7 AM VietNam time
    region = "us-central1"
    http_target {
        uri = "https://www.googleapis.com/sql/v1beta4/projects/learning-cloud-with-fpt/instances/petclinic-sql-instance"
        http_method = "PATCH"
        body = base64encode(jsonencode({
            settings = {
                activationPolicy = "ALWAYS"
            }
        }))
        oauth_token {
            service_account_email = "sql-admin@learning-cloud-with-fpt.iam.gserviceaccount.com"
            scope = "https://www.googleapis.com/auth/cloud-platform"
        }
    }
}
