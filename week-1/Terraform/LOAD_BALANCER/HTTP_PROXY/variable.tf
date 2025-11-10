variable "proxy_name" {
    type = string
    description = "Name of your proxy"
}

variable "url_map_id" {
    type = string
    description = "A reference to the UrlMap resource that defines the mapping from URL to the BackendService."
}

variable "proxy_description" {
    type = string
    description = "An optional description of this resource."
}