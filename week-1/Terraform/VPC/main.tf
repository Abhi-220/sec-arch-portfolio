# Description: This below block contains the code to create a VPC network in GCP

resource "google_compute_network" "network" {

    name = var.network_name
    # Name of the network

    description = var.network_description
    # Description of the network

    auto_create_subnetworks = var.auto_create_subnetworks
    # Whether to create subnetworks automatically
    # Default is true
    # Set to false if you want to create subnetworks manually

    routing_mode = var.routing_mode
    # The network-wide routing mode to use
    # Default is REGIONAL

    mtu = var.mtu
    # Maximum Transmission Unit (MTU) of the network
    # Default is 1460
}


# Description: This below block contains the code to create a subnet in the VPC network

resource "google_compute_subnetwork" "subnetwork" {

    name = var.subnet_name
    # Name of the subnet

    network = var.network_name
    # Name of the network in which the subnet is created

    description = var.subnet_description
    # Description of the subnet

    ip_cidr_range = var.ip_cidr_range
    # IP CIDR range of the subnet

    secondary_ip_range {
        range_name = var.range_name
        # Name of the secondary IP range

        ip_cidr_range = var.ip_range
        # IP CIDR range of the secondary IP range
    }

    secondary_ip_range {
        range_name = var.range_name_1
        # Name of the secondary IP range

        ip_cidr_range = var.ip_range_1
        # IP CIDR range of the secondary IP range
    }

    private_ip_google_access = var.private_ip_google_access
    # Whether VMs in this subnet can access Google services without a public IP address
    # Default is false

    region = var.region
    # Region in which the subnet is created

    log_config {
        metadata = var.metadata
        # Metadata logging configuration
        # Default is INCLUDE_ALL_METADATA
        # Values incude EXCLUDE_ALL_METADATA, INCLUDE_ALL_METADATA, CUSTOM_METADATA
    }

    depends_on = [ google_compute_network.network ]
}

