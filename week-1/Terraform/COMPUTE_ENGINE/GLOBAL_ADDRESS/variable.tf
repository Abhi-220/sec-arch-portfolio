variable "global_ip_name" {
    type = string
    description = "The name of the global IP address"
}

variable "global_ip_description" {
    type = string
    description = "The description of the global IP address"
}

variable "global_ip_labels" {
    type = map(string)
    description = "The labels to apply to the global IP address"
}

variable "global_ip_version" {
    type = string
    description = "The IP version that will be used by the global IP address"   
    default = "IPV4"
}

variable "global_ip_address_type" {
    type = string
    description = "The type of address to reserve"
    default = "EXTERNAL"
}