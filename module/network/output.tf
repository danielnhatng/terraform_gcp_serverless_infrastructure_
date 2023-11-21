output "petclinic-vpc" {
    value = google_compute_network.vpc-petclinic.self_link
}

output "petclinic-vpc-name" {
    value = google_compute_network.vpc-petclinic.name
}

output "petclinic-subnet" {
    value = google_compute_subnetwork.subnet-petclinic.id
}

