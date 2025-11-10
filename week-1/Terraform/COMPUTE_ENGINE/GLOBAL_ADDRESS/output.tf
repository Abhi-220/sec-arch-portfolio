output "global_ip_address" {
    value = google_compute_global_address.global_ip.self_link
}