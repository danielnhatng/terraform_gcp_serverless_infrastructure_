resource "google_compute_global_forwarding_rule" "petclinic-frontend" {
    name = "petclinic-frontend"
    ip_protocol = "TCP"
    port_range = 80
    ip_address = var.ip_address
    load_balancing_scheme = "EXTERNAL_MANAGED"
    project = var.project
    target = google_compute_target_http_proxy.petclinic-http-proxy.id
}

resource "google_compute_target_http_proxy" "petclinic-http-proxy" {
    name = "petclinic-target-proxy"
    url_map = google_compute_url_map.petclinic-urlmap.self_link
}

resource "google_compute_url_map" "petclinic-urlmap" {
    name = "petclinic-url-map"
    default_service = var.backend_url
}   