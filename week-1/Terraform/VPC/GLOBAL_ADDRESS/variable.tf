variable "vpc_peering_ip_name" {
    type = string
    description = "The name of the global address resource."
}

variable "vpc_peering_ip_purpose" {
    type = string
    description = "The purpose of the global address resource."
}

variable "vpc_peering_ip_address_type" {
    type = string
    description = "The type of address to reserve."
}

variable "vpc_peering_ip_network" {
    type = string
    description = "The network that the global address is reserved for."
}

variable "vpc_peering_prefix_length" {
    type = string
    description = "The prefix length if the purpose is VPC_PEERING."
}
