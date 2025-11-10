variable "url_map_name" {
    type = string
    description = "URL map name"
}

variable "backend_service_id" {
    type = string
    description = "The default backend service to which traffic is directed if none of the hostRules match."
}

variable "url_map_description" {
    type = string
    description = "An optional description of this resource."
}

