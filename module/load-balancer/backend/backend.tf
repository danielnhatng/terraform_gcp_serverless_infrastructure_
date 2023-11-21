resource "google_compute_backend_service" "petclinic-backend" {
    name = "petclinic-backend"
    protocol = "HTTP"
    port_name = "http"
    enable_cdn = false
    load_balancing_scheme = "EXTERNAL_MANAGED"
    locality_lb_policy = "ROUND_ROBIN"
    session_affinity = "NONE"
    log_config {
        enable = false
    }
    backend {
        balancing_mode = "UTILIZATION"
        capacity_scaler = 1
        group = google_compute_region_network_endpoint_group.petclinic-endpoint.self_link
    }
}


resource "google_compute_region_network_endpoint_group" "petclinic-endpoint" {
    name = "petclinic-endpoint"
    region = "us-central1"
    network_endpoint_type = "SERVERLESS"
    cloud_run {
        service = var.cloudrun_name
    }
}