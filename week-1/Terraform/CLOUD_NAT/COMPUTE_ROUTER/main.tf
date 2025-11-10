resource "google_compute_router" "router" {

    name = var.router_name
    # Name of the router

    network = var.network_name
    # Name of the network to which the router belongs

    description = var.router_description
    # Description of the router

    region = var.router_region
    #   Region of the router

}