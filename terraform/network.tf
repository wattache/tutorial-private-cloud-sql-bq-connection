module "network" {
    source  = "terraform-google-modules/network/google"
    version = "5.0.0"

    project_id   = var.project_id
    network_name = "my-vpc"
    routing_mode = "REGIONAL"

    subnets = [
        {
            subnet_name           = "my-subnet"
            subnet_ip             = "10.114.0.0/16"
            subnet_region         = var.region
            subnet_private_access = "true"
        }       
    ]

    firewall_rules = [
      {
        name        = "allow-all-https-ingress"
        description = "Allow all HTTPS ingress."
        direction   = "INGRESS"
        priority    = 0
        ranges = ["0.0.0.0/0"]
        allow = [
          {
            protocol = "tcp"
            ports    = ["80"] # HTTPS
          }
        ]
      },
      {
        name        = "allow-all-http-ingress"
        description = "Allow all HTTP ingress."
        direction   = "INGRESS"
        priority    = 0
        ranges = ["0.0.0.0/0"]
        allow = [
          {
            protocol = "tcp"
            ports    = ["443"] #HTTP
          }
        ]
      },
      {
        name        = "allow-all-ssh-ingress"
        description = "Allow all SSH ingress."
        direction   = "INGRESS"
        priority    = 0
        ranges = ["0.0.0.0/0"]
        allow = [
          {
            protocol = "tcp"
            ports    = ["22"] #SSH
          }
        ]
      }
    ]

}

resource "google_compute_global_address" "private_ip_address" {
    name = "my-private-ip-address"
    project = var.project_id
    purpose = "VPC_PEERING"
    address_type = "INTERNAL"
    prefix_length = 16
    network = module.network.network_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
    network = module.network.network_id
    service = "servicenetworking.googleapis.com"
    reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
