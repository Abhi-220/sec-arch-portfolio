output "network_name" {
    value = google_compute_network.network.name
}

output "subnet_name" {
    value = google_compute_subnetwork.subnetwork.name
}

# VPC/outputs.tf

output "ip_cidr_range" {
  description = "The IP CIDR range for the VPC network"
  value       = google_compute_subnetwork.subnetwork.ip_cidr_range
}


output "range_name" {
  description = "The name of the secondary IP range"
  value       = google_compute_subnetwork.subnetwork.secondary_ip_range[0].range_name
}

output "range_name_1" {
  description = "The name of the secondary IP range"
  value       = google_compute_subnetwork.subnetwork.secondary_ip_range[1].range_name 
}
