resource "google_storage_bucket" "source_data_bucket" {
  project                     = var.project_id
  name                        = "source-data-bucket-${var.project_id}"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
}