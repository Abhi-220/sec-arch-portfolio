resource "google_redis_instance" "instance" {

    name = var.instance_name
    # Name of the Redis instance

    memory_size_gb = var.memory_size_gb
    # Redis memory size in GiB. Minimum of 1GB for BASIC tier and 5GB for STANDARD_HA tier

    tier = var.instance_tier
    # BASIC or STANDARD_HA

    region = var.instance_region
    # Region where the instance will be created

    location_id = var.instance_location_id
    # Zone where the instance will be created

    authorized_network = var.instance_authorized_network
    # Network that the instance will be connected to

    connect_mode = var.instance_connect_mode
    # Possible values are: DIRECT_PEERING, PRIVATE_SERVICE_ACCESS
   
}