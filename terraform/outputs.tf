output "ip-addres-lb" {
  description = "External IP of the load balancer (petclinic app)"
  value       = module.network.cp-ext-ip-bm
}

output "ip-address-db" {
  description = "Public IP of the database"
  value       = module.database.db_ip
}

output "ip-address-instance-1" {
  description = "External IP of Compute Instance 1"
  value = module.compute.ip-address-vm1
}

output "ip-address-instance-2" {
  description = "External IPs of Compute Instance 2"
  value = module.compute.ip-address-vm2
}