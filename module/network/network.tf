resource "google_compute_network" "vpc-petclinic" {
    name = "petclinic-vpc-network"
    auto_create_subnetworks = false
    routing_mode = "REGIONAL"
    project = var.project
}

resource "google_compute_subnetwork" "subnet-petclinic" {
    name = "petclinic-subnet"
    network = google_compute_network.vpc-petclinic.self_link
    region = "us-central1"
    ip_cidr_range = "10.128.0.0/20"
    private_ip_google_access = true
}

resource "google_compute_firewall" "petclinic-allow-internal" {
    name    = "petclinic-allow-internal"
    network = google_compute_network.vpc-petclinic.self_link
    direction = "INGRESS"

    allow {
        protocol = "tcp"
        ports = [ 22 , 80, 443]
    }

    source_ranges = ["10.128.0.0/20"] 

    priority = 1000

}

resource "google_compute_firewall" "nhatnd19-allow-healthcheck" {
    name    = "petclinic-allow-healthcheck"
    network = google_compute_network.vpc-petclinic.self_link
    direction = "INGRESS"

    allow {
        protocol = "tcp"
        ports = [80]
    }

    source_ranges = ["35.191.0.0/16", "130.211.0.0/22"] 
    priority = 1000
}

resource "google_compute_firewall" "nhatnd19-allow-ssh" {
    name    = "petclinic-allow-ssh"
    network = google_compute_network.vpc-petclinic.self_link
    direction = "INGRESS"

    allow {
        protocol = "tcp"
        ports = [ 22 ]
    }

    source_ranges = ["35.235.240.0/20"] 

    priority = 1000

}

#Private ip for peering connection
resource "google_compute_global_address" "private_ip_address" {
    name          = "petclinic-private-ip"
    purpose       = "VPC_PEERING"
    address_type  = "INTERNAL"
    prefix_length = 16
    network       = google_compute_network.vpc-petclinic.name
}

resource "google_service_networking_connection" "private_vpc_connection" {
    network                 = google_compute_network.vpc-petclinic.name
    service                 = "servicenetworking.googleapis.com"
    reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}