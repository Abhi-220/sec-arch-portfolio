variable "instance_name" {
    type = string
    description = "Name of the Redis instance"
}

variable "memory_size_gb" {
    type = string
    description = "Redis memory size in GiB. Minimum of 1GB for BASIC tier and 5GB for STANDARD_HA tier"
}

variable "instance_tier" {
    type = string
    description = "BASIC or STANDARD_HA"
}

variable "instance_region" {
    type = string
    description = "Region where the instance will be created"
}

variable "instance_location_id" {
    type = string
    description = "Zone where the instance will be created"
}

variable "instance_authorized_network" {
    type = string
    description = "Network that the instance will be connected to"
}

variable "instance_connect_mode" {
    type = string
    description = "Possible values are: DIRECT_PEERING, PRIVATE_SERVICE_ACCESS"
}