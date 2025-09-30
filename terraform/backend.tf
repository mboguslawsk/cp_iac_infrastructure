resource "google_storage_bucket" "default" {
  name     = "cp-tfstate-bucket-bm"
  location = "EU"

  force_destroy               = true
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}