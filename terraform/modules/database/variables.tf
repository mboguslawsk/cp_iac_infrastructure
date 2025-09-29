variable "region" {
  description = "Region for the DB, ie. europe-west1"
}

variable "db_username" {
  description = "Username for the DB"
  sensitive = true
}

variable "db_password" {
  description = "Password for the DB"
  sensitive = true
}