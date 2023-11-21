resource "google_cloud_run_v2_service" "petclinic-cloud_run" {
    name = "spring-petclinic"
    project = var.project
    location = "us-central1"
    launch_stage = "BETA"
    ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
    template {
        containers {
            image = var.image
            liveness_probe {
                initial_delay_seconds = 300
                period_seconds = 60
                timeout_seconds = 60
                failure_threshold = 5
                http_get {
                    path = "/"
                }
            }
            ports {
                container_port = "8080" #Default port
            }
        }   
        service_account = "cloudrun@learning-cloud-with-fpt.iam.gserviceaccount.com"
        scaling {
            max_instance_count = 4
            min_instance_count = 2
        }
        volumes {
            name = "cloudsql"
            cloud_sql_instance {
                instances = [var.cloud_instance]
            }
        }
        vpc_access {
            network_interfaces {
                network = var.vpc-name
                subnetwork = var.subnet
            }
        }
        
            
        
    }
    
    traffic {
        percent = 100
        type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    }
}


resource "google_cloud_run_service_iam_member" "member" {
    location = google_cloud_run_v2_service.petclinic-cloud_run.location
    project = google_cloud_run_v2_service.petclinic-cloud_run.project
    service = google_cloud_run_v2_service.petclinic-cloud_run.name
    role = "roles/run.invoker"
    member = "allUsers"
}

