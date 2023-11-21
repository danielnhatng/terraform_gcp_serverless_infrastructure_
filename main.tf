terraform {
    required_providers {
        google = {
        source = "hashicorp/google"
        version = "5.5.0"
        }
    }
}


provider "google" {
    credentials = file("learning-cloud-with-fpt-a96d80f37be1.json")
    project = "learning-cloud-with-fpt"
}


# module "repository" {
#     source = "./module/cloud-repo"
# }

module "secret_manager" {
    source = "./module/secret_manager"
}

module "static_ip" {
    source = "./module/static-ip"
}

module "network" {
    source = "./module/network"  
    project = var.project_name
}

module "sql" {
    source = "./module/sql"
    project = var.project_name
    network = module.network.petclinic-vpc
    latest_db_pass = module.secret_manager.latest_password
    depends_on = [ module.network ]
}

module "cloudrun" {
    source = "./module/cloudrun"
    project =  var.project_name
    cloud_instance = module.sql.cloud_sql_instance
    vpc-name =  module.network.petclinic-vpc-name
    subnet = module.network.petclinic-subnet
    image = var.petclinic_image
    depends_on = [ module.sql ]
}

module "backend" {
    source = "./module/load-balancer/backend"
    cloudrun_name = module.cloudrun.cloudrun_name
    depends_on = [ module.network, module.cloudrun ]
}

module "frontend" {
    source = "./module/load-balancer/frontend"
    ip_address = module.static_ip.static_ip
    project = var.project_name
    backend_url = module.backend.backend_url
    network = module.network.petclinic-vpc
    depends_on = [ module.backend ]
}

module "logging" {
    source = "./module/logging-bucket"
    project_name = var.project_name
}

module "alert" {
    source = "./module/alert"
}

module "cronjob" {
    source = "./module/cronjob"
}