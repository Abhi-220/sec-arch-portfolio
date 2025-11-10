variable "project_id" {
    type = string
    description = "The project ID to deploy resources"
}

variable "region" {
    type = string
    description = "The region to deploy resources"
}


variable "kubernetes_sa_account_id" {
    type = string
    description = "ID for your kubernetes account ID"
}

variable "kubernetes_sa_display_name" {
    type = string
    description = "Display name for your kubernetes account"
}

variable "kubernetes_sa_description" {
    type = string
    description = "Description for your kubernetes account"
}


variable "kubernetes_sa_roles" {
    type = list(string)
    description = "Roles for your kubernetes account"
}



variable "network_name" {
    type = string
    description = "The name of the network"
}

variable "network_description" {
    type = string
    description = "The description of the network"
}


variable "subnet_name" {
    type = string
    description = "The name of the subnet"
}

variable "subnet_description" {
    type = string
    description = "The description of the subnet"
}

variable "ip_cidr_range" {
    type = string
    description = "The IP CIDR range of the subnet"
}

variable "range_name" {
    type = string
    description = "The name of the secondary range"
}

variable "ip_range" {
    type = string
    description = "The IP CIDR range of the secondary range"
}   

variable "range_name_1" {
    type = string
    description = "The name of the secondary range"
}

variable "ip_range_1" {
    type = string
    description = "The IP CIDR range of the secondary range"
}






variable "cluster_name" {
    type = string
    description = "The name of the GKE cluster"
}

variable "cluster_description" {
    type = string
    description = "The description of the GKE cluster"
}

variable "initial_node_count" {
    type = string
    description = "The initial number of nodes in the GKE cluster"
}

variable "master_ipv4_cidr_block" {
    type = string
    description = "The IP CIDR range of the master"
}


variable "master_access_cidr_block" {
    type = string
    description = "The IP CIDR range of the master"
}

variable "display_name" {
    type = string
    description = "The display name of the GKE cluster"
}




variable "node_pool_name" {
    type = string
    description = "The name of the node pool"
}

variable "reg_node_location" {
    type = list(string)
    description = "The region of the node pool"
}

variable "max_pods_per_node" {
    type = string
    description = "The maximum number of pods per node"
}

variable "disk_size" {
    type = string
    description = "The disk size of the node pool"
}

variable "disk_type" {
    type = string
    description = "The disk type of the node pool"
}

variable "image_type" {
    type = string
    description = "The image type of the node pool"
}

variable "pool_labels" {
    type = map(string)
    description = "The labels of the node pool"
}

variable "machine_type" {
    type = string
    description = "The machine type of the node pool"
}

/**
variable "node_service_account" {
    type = string
    description = "The service account of the node pool"
}
**/

variable "node_count" {
    type = string
    description = "The number of nodes in the node pool"
}

variable "min_node_count" {
    type = string
    description = "The minimum number of nodes in the node pool"
}

variable "max_node_count" {
    type = string
    description = "The maximum number of nodes in the node pool"
}




variable "router_name" {
    type = string
    description = "The name of the router"
}

variable "router_description" {
    type = string
    description = "The description of the router"
}


variable "nat_name" {
    type = string
    description = "The name of the NAT"
}

variable "nginix_namespace_name" {
    type = string
    description = "The name of the namespace"
}


variable "nginix_ingress_release_name" {
    type = string
    description = "The name of the helm release"
}


variable "nginix_ingress_repository" {
    type = string
    description = "The repository of the helm release"
}


variable "nginix_ingress_chart" {
    type = string
    description = "The chart of the helm release"
}


variable "health_check_name" {
    type = string
    description = "The name of the health check"
}

variable "health_check_description" {
    type = string
    description = "The description of the health check"
}



variable "backend_service_name" {
    type = string
    description = "The name of the backend service"
}

variable "backend_service_description" {
    type = string
    description = "The description of the backend service"
  
}

variable "http_firewall_name" {
    type = string
    description = "The name of the firewall rule"
}

variable "http_firewall_description" {
    type = string
    description = "The description of the firewall rule"
}

variable "http_firewall_direction" {
    type = string
    description = "The direction of the firewall rule"
}   

variable "http_allow_protocols" {
    type = string
    description = "The protocol to allow"
}

variable "http_allow_ports" {
    type = list(number)
    description = "The list of ports to allow"
    default = []
}

variable "source_ranges" {
    type = list(string)
    description = "The list of IP ranges in CIDR format that the rule applies to"
    default = []
}






variable "allow_http_firewall_name" {
    type = string
    description = "Name of the firewall rule"
}

variable "allow_http_firewall_description" {
    type = string
    description = "Description for your firewall rule"
}

variable "allow_http_firewall_direction" {
    type = string
    description = "Traffic Direction of the firewall rule"
}

variable "allow_http_allow_protocols" {
    type = string
    description = "The protocol to allow"
}

variable "allow_http_allow_ports" {
    type = list(number)
    description = "The list of ports to allow"
}

variable "http_source_ranges" {
    type = list(string)
    description = "The list of IP ranges in CIDR format that the rule applies to "
}


variable "allow_https_firewall_name" {
    type = string
    description = "Name of the firewall rule"
}

variable "allow_https_firewall_description" {
    type = string
    description = "Description for your firewall rule"
}

variable "allow_https_firewall_direction" {
    type = string
    description = "Traffic Direction of the firewall rule"
}

variable "allow_https_allow_protocols" {
    type = string
    description = "The protocol to allow"
}

variable "allow_https_allow_ports" {
    type = list(number)
    description = "The list of ports to allow"
}

variable "https_source_ranges" {
    type = list(string)
    description = "The list of IP ranges in CIDR format that the rule applies to "
}


variable "global_ip_name" {
    type = string
    description = "The name of the global IP"
}

variable "global_ip_description" {
    type = string
    description = "The description of the global IP"
}

variable "global_ip_labels" {
    type = map(string)
    description = "The labels of the global IP"
}




variable "url_map_name" {
    type = string
    description = "The name of the URL map"
}

variable "url_map_description" {
    type = string
    description = "The description of the URL map"
}



variable "http_proxy_name" {
    type = string
    description = "The name of the HTTP proxy"
}

variable "http_proxy_description" {
    type = string
    description = "The description of the HTTP proxy"
}


variable "frontend_name" {
    type = string
    description = "The name of the frontend"
}

variable "frontend_description" {
    type = string
    description = "The description of the frontend"
}

variable "frontend_port" {
    type = number
    description = "The port of the frontend"
}



variable "topic_name" {
    type = string
    description = "Name of the Pub/Sub topic"
}



variable "subscription_name" {
    type = string
    description = "Name of the Pub/Sub subscription"
}

variable "labels" {
    type = map(string)
    description = "Labels for your subscription"
}

variable "ack_deadline_seconds" {
    type = string
    description = "The ack deadline for the subscription"
}

variable "message_retention_duration" {
    type = string
    description = "The message retention duration for the subscription"
}

variable "expiration_policy_ttl" {
    type = string
    description = "The expiration policy TTL for the subscription"
}





variable "vpc_peering_ip_name" {
    type = string
    description = "Name of the VPC peering IP"
}

variable "vpc_peering_ip_purpose" {
    type = string
    description = "Purpose of the VPC peering IP"
}

variable "vpc_peering_ip_address_type" {
    type = string
    description = "Address type of the VPC peering IP"
}


variable "vpc_peering_prefix_length" {
    type = string
    description = "Prefix length for the VPC peering IP"
}





variable "instance_name" {
    type = string
    description = "Name of the Redis instance"
}

variable "memory_size_gb" {
    type = string
    description = "Memory size for the Redis instance"
}

variable "instance_tier" {
    type = string
    description = "Tier for the Redis instance"
}

variable "instance_region" {
    type = string
    description = "Region for the Redis instance"
}

variable "instance_location_id" {
    type = string
    description = "Location ID for the Redis instance"
}


variable "instance_connect_mode" {
    type = string
    description = "Connect mode for the Redis instance"
}

variable "adapter_namespace_name" {
    type = string
    description = "Name of the namespace where you want to deploy"
}


variable "adapter_ksa_name" {
    type = string
    description = "Name of the service account for the adapter"
}



variable "bucket_sa_account_id" {
    type = string
    description = "ID for your bucket account ID"
}

variable "bucket_sa_display_name" {
    type = string
    description = "Display name for your bucket account"
}

variable "bucket_sa_description" {
    type = string
    description = "Description for your bucket account"
}



variable "bucket_sa_roles" {
    type = list(string)
    description = "Roles for your bucket account"
}



variable "config_bucket_name" {
    type = string
    description = "The name of the bucket to store your configs"
}


