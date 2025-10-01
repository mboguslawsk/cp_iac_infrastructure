# ======================================================================
# ======================= Load Balancer ================================
# ======================================================================


# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "cp-xlb-forwarding-rule-bm"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = var.ext-ip-id
}

# http proxy
resource "google_compute_target_http_proxy" "default" {
  name     = "cp-xlb-target-http-proxy-bm"
  url_map  = google_compute_url_map.default.id
}

# url map
resource "google_compute_url_map" "default" {
  name            = "cp-xlb-url-map-bm"
  default_service = google_compute_backend_service.default.id
}

# health check
resource "google_compute_health_check" "default" {
  name     = "cp-l7-xlb-hc-bm"
  http_health_check {
    port = "80"
  }
}

resource "google_compute_address" "ip_address_1" {
  name = "cp-ext-ip-1"
  region = var.cp-region
}

resource "google_compute_address" "ip_address_2" {
  name = "cp-ext-ip-2"
  region = var.cp-region
}

# instance 1
resource "google_compute_instance" "cp-app-vm1" {
  name         = "cp-instance-1-bm"
  machine_type = "e2-medium"
  zone         = var.cp-zone-for-mig
  tags         = ["allow-health-check", "ssh-access"]

  # Network interface with external IP
  network_interface {
    network    = var.cp-network
    subnetwork = var.cp-subnetwork
    access_config {
      nat_ip = google_compute_address.ip_address_1.address
    }
  }

  # Boot disk
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
    auto_delete = true
  }

  # Startup script to install nginx and serve a page
  metadata_startup_script = file("modules/network/startupscript.sh")

  # Metadata for SSH access
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/terraform_gce_key.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }

  
}

# instance 2
resource "google_compute_instance" "cp-app-vm2" {
  name         = "cp-instance-2-bm"
  machine_type = "e2-medium"
  zone         = var.cp-zone-for-mig
  tags         = ["allow-health-check", "ssh-access"]

  # Network interface with external IP
  network_interface {
    network    = var.cp-network
    subnetwork = var.cp-subnetwork
    access_config {
      nat_ip = google_compute_address.ip_address_2.address
    }
  }

  # Boot disk
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
    auto_delete = true
  }

  # Startup script to install nginx and serve a page
  metadata_startup_script = file("modules/network/startupscript.sh")

  lifecycle {
    create_before_destroy = true
  }
}



resource "google_compute_instance_group" "cp-app-group" {
  name = "cp-app-group"
  zone = var.cp-zone-for-mig
  instances = [
    google_compute_instance.cp-app-vm1.self_link, 
    google_compute_instance.cp-app-vm2.self_link
  ]
}




# backend service
resource "google_compute_backend_service" "default" {
  name                    = "cp-xlb-backend-service-bm"
  protocol                = "HTTP"
  port_name               = "http"
  load_balancing_scheme   = "EXTERNAL"
  timeout_sec             = 10
  enable_cdn              = true
  health_checks           = [google_compute_health_check.default.id]
  backend {
    group           = google_compute_instance_group.cp-app-group.self_link
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}



# # MIG
# resource "google_compute_instance_group_manager" "default" {
#   name     = "cp-l7-xlb-mig1-bm"
#   zone     = var.cp-zone-for-mig
#   named_port {
#     name = "http"
#     port = 80
#   }
#   version {
#     instance_template = google_compute_instance_template.default.id
#     name              = "primary"
#   }
#   base_instance_name = "cp-vm"
#   target_size        = 3
# }

# ======================================================================
# ======================================================================




output "ip-address-vm1" {
  # value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
  value = google_compute_address.ip_address_1.address
}

output "ip-address-vm2" {
  # value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
  value = google_compute_address.ip_address_2.address
}