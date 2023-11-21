output "backend_url" {
    value = google_compute_backend_service.petclinic-backend.self_link
}