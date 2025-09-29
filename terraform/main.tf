module "network" {
  source = "./modules/network"
  region = var.region
}

module "compute" {
  source          = "./modules/compute"
  cp-network      = module.network.cp-network
  cp-subnetwork   = module.network.cp-subnetwork
  cp-zone-for-mig = var.cp-zone-for-mig
  ext-ip          = module.network.cp-ext-ip-bm
  ext-ip-id       = module.network.cp-ext-ip-id-bm
  cp-region = var.region
}

module "database" {
  source = "./modules/database"
  region = var.region
  db_username = var.db_username
  db_password = var.db_password
}
