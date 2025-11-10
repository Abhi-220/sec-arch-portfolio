resource "google_compute_target_http_proxy" "proxy" {
    name = var.proxy_name 
    # Name of your proxy
    
    url_map = var.url_map_id
    # A reference to the UrlMap resource that defines the mapping from URL to the BackendService.

    description = var.proxy_description
    # An optional description of this resource.
}