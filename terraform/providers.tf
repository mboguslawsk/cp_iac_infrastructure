terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.3.0"
    }
  }

  # backend "gcs" {
  #   bucket = "cp-tfstate-bucket-bm"
  #   prefix = "terraform/state"
  # }
}

provider "google" {
  project = var.project_id
}
