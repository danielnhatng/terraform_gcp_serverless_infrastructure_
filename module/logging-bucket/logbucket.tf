resource "google_logging_project_bucket_config" "petclinic-log" {
    bucket_id= "petclinic-cloudrun-logging"
    project = var.project_name
    location = "us-central1"
    enable_analytics = true
    retention_days = 10
    
}

resource "google_logging_project_sink" "petclinic-sink" {
    name = "petclinic-sink"
    destination = "logging.googleapis.com/projects/learning-cloud-with-fpt/locations/us-central1/buckets/petclinic-cloudrun-logging"
    filter = "resource.type=cloud_run_revision & resource.labels.service_name=spring-petclinic & resource.type=cloudsql_database & httpRequest.requestMethod=GET"
}