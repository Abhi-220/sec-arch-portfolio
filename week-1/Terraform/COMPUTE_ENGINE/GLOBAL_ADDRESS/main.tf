resource "google_compute_global_address" "global_ip" {
    name = var.global_ip_name
    description = var.global_ip_description
    labels = var.global_ip_labels
    ip_version = var.global_ip_version
    address_type = var.global_ip_address_type
}
