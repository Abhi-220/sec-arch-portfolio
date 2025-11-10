variable "nat_name" {
    type = string
    description = "Name of the NAT"
}

variable "source_subnetwork_ip_ranges_to_nat" {
    type = string
    description = "List of subnetwork ip ranges to NAT"
    default = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "router_name" {
    type = string
    description = "Name of the router assigned to the NAT"
}

variable "nat_ip_allocate_option" {
    type = string
    description = "Option to allocate NAT IP"
    default = "AUTO_ONLY"
}

variable "log_enable" {
    type = bool
    description = "Enable logging"
    default = true
}

variable "log_filter" {
    type = string
    description = "Filter for logging"
    default = "ALL"
}

variable "endpoint_types" {
    type = list(string)
    description = "List of types of endpoints to which NAT applies"
    default = ["ENDPOINT_TYPE_VM"]
}

variable "nat_region" {
    type = string
    description = "Region of the NAT"
}

variable "project_id" {
    type = string
    description = "Project ID of the NAT"
}

