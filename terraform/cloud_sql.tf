module "sql_db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version = "10.1.0"

  # Create a MySQL instance
  project_id        = var.project_id
  database_version  = "MYSQL_8_0"
  name              = var.mysql_instance_name
  region            = var.region
  zone              = var.zone
  availability_type = "ZONAL"
  ip_configuration = {
    allocated_ip_range  = google_compute_global_address.private_ip_address.name
    authorized_networks = []
    ipv4_enabled        = true
    private_network     = module.network.network_id
    require_ssl         = false
  }

  tier            = "db-f1-micro"
  disk_type       = "PD_HDD"
  disk_size       = "10"
  disk_autoresize = "false"

  create_timeout = "20m"
  update_timeout = "20m"
  delete_timeout = "20m"

  deletion_protection = "false"

  # Create a database
  db_name       = var.mysql_database_name
  user_name     = var.mysql_username
  user_password = var.mysql_password

  depends_on = [
    module.network.network_name,
    google_compute_global_address.private_ip_address,
    google_service_networking_connection.private_vpc_connection,
  ]

}
