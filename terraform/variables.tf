variable "region" {
  description = "Region for the network, ie. europe-west1"
}

variable "project_id" {
  description = "Name of the project in GCP"
}

variable "cp_zone_for_mig" {
  description = "Zone for the MIG, ie. europe-west1-b"
}

variable "db_username" {
  description = "Username for the DB"
  sensitive = true
}

variable "db_password" {
  description = "Password for the DB"
  sensitive = true
}

