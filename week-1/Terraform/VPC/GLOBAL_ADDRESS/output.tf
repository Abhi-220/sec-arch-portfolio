output "reserved_ip_range" {
  value = google_compute_global_address.vpc_peering_ip.name
}
