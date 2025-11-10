resource "google_compute_url_map" "url_map" {

    # URL map is a resource that defines the mapping of URLs to backend services.
    # URL maps are used in external HTTP(S) load balancers and SSL proxy load balancers.

    name = var.url_map_name 
    # URL map name

    default_service = var.backend_service_id
    # The default backend service to which traffic is directed if none of the hostRules match.

    description = var.url_map_description
    # An optional description of this resource.
}