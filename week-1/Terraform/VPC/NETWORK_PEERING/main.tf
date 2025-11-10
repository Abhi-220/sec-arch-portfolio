resource "google_compute_network_peering" "name" {
    name = var.peering_name
    network = var.network
    peer_network = var.peer_network
}