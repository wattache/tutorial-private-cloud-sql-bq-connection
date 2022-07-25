resource "google_bigquery_connection" "connection" {
    project       = var.project_id
    friendly_name = "my_sql_connection"
    description   = "A connection between CloudSQL and BigQuery."
    location      = var.region
    cloud_sql {
        instance_id = module.sql_db.instance_connection_name
        database    = var.mysql_database_name
        type        = "MYSQL"
        credential {
          username = var.mysql_username
          password = var.mysql_password
        }
    }
}