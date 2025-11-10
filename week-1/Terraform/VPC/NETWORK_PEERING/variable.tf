variable "peering_name" {
    type = string
    description = "The name of the network peering"
}

variable "network" {
    type = string
    description = "The name of the network"
}

variable "peer_network" {
    type = string
    description = "The name of the peer network"
}