resource "google_compute_global_address" "vpc_peering_ip" {
    name = var.vpc_peering_ip_name
    purpose = var.vpc_peering_ip_purpose
    address_type = var.vpc_peering_ip_address_type
    prefix_length = var.vpc_peering_prefix_length
    network = var.vpc_peering_ip_network
}