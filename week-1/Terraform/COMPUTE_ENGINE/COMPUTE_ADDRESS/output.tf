output "ip_address" {
    value = google_compute_address.external_ip_address.self_link
}