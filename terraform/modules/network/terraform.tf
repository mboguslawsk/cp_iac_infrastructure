resource "google_compute_network" "cp-vm-vpc" {
  name                    = "cp-vm-net-bm"
  auto_create_subnetworks = false
}


# ======================================================================
# ======================= Load Balancer ================================
# ======================================================================


# subnet - for backend for MIG for load balancer 
resource "google_compute_subnetwork" "default" {
  name          = "cp-lb-mig-subnet-vm-bm"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.cp-vm-vpc.id
}

resource "google_compute_global_address" "default" {
  name     = "cp-lb-global-ip-bm"
}

resource "google_compute_firewall" "allow-http" {
  name    = "cp-allow-http-bm"
  network = google_compute_network.cp-vm-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-allow"]
}

# # allow access from health check ranges
# resource "google_compute_firewall" "default" {
#   name          = "cp-l7-xlb-fw-allow-hc-bm"
#   direction     = "INGRESS"
#   network       = google_compute_network.cp-vm-vpc.id
#   source_ranges = ["0.0.0.0/0"]
#   allow {
#     protocol = "tcp"
#   }
#   target_tags = ["allow-health-check"]
# }

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.cp-vm-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["ssh-access"]
}

# ======================================================================
# ======================================================================


output "cp-network" {
  value = google_compute_network.cp-vm-vpc.id
}

output "cp-subnetwork" {
  value = google_compute_subnetwork.default.id
}


output "cp-ext-ip-bm" {
  value = google_compute_global_address.default.address
}

output "cp-ext-ip-id-bm" {
  value = google_compute_global_address.default.id
}