variable "project_id" {
  description = "Id of the project in which to deploy."
  type        = string
}

variable "region" {
  description = "Region where resources are instantiated."
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "Zone where resources are instantiated."
  type        = string
  default     = "europe-west1-b"
}

variable "mysql_instance_name" {
  description = "MySQL instance name."
  type        = string
  default     = "my-mysql-instance"
}

variable "mysql_database_name" {
  description = "Name of the CloudSQL database."
  type        = string
  default     = "unicorns_market"
}

variable "mysql_username" {
  description = "MySQL user name."
  type        = string
  default     = "uniunicorn"
}

variable "mysql_password" {
  description = "MySQL user password."
  type        = string
  default     = "1HornBetterThan2!"
}
