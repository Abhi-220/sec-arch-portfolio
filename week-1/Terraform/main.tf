#--------------------------------------------- Provider Configuration ---------------------------------------------#

provider "google" {
  project = var.project_id
  region  = var.region
}

#--------------------------------------------- Data Configuration for project ID ---------------------------------------------#
data "google_project" "project" {
  project_id = var.project_id
}

/**
#--------------------------------------------- Terraform Backend Configuration ---------------------------------------------#
terraform {
  backend "gcs" {
    bucket = "beckn-backend-bucket"
    prefix = "terraform/one-click"
  }
}
**/

#--------------------------------------------- Resource Configuration for enabling APIs ---------------------------------------------#

/**
#Compute Engine API
resource "google_project_service" "compute_engine" {
  project = var.project_id
  service = "compute.googleapis.com"

  disable_on_destroy = false
  lifecycle {
    prevent_destroy = true
  }
}

#Waiting for the Compute Engine API to be enabled
resource "time_sleep" "wait_for_compute" {
  depends_on = [google_project_service.compute_engine]

  create_duration = "120s" # Adjust the wait time as needed
}



#Kubernetes Engine API
resource "google_project_service" "kubernetes_engine" {
  project = var.project_id
  service = "container.googleapis.com"

  disable_on_destroy = false
  lifecycle {
    prevent_destroy = true
  }
}

#Waiting for the Kubernetes Engine API to be enabled
resource "time_sleep" "wait_for_kubernetes" {
  depends_on = [google_project_service.kubernetes_engine]

  create_duration = "120s" # Adjust wait time as needed
}

#Cloud Resource Manager API
resource "google_project_service" "cloud_resource_manager" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_on_destroy = false
  lifecycle {
    prevent_destroy = true
  }
}

#Waiting for the Cloud Resource Manager API to be enabled
resource "time_sleep" "wait_for_resource_manager" {
  depends_on = [google_project_service.cloud_resource_manager]

  create_duration = "120s" # Adjust wait time as needed
}

#Private Service Access API
resource "google_project_service" "private_service_access" {
  project = var.project_id  # Replace with your project ID
  service = "servicenetworking.googleapis.com"
  disable_on_destroy = false
  lifecycle {
    prevent_destroy = true
  }
}

#Waiting for the Private Service Access API to be enabled
resource "time_sleep" "wait_for_psa" {
    depends_on = [ resource.google_project_service.private_service_access ]
    create_duration = "120s"
}


#Secret Manager API
resource "google_project_service" "secret_manager" {
  project = var.project_id
  service = "secretmanager.googleapis.com"

  disable_on_destroy = false
  lifecycle {
    prevent_destroy = true
  }
}

#Waiting for the Secret Manager API to be enabled
resource "time_sleep" "wait_for_secret_manager" {
  depends_on = [google_project_service.secret_manager]

  create_duration = "120s" # Adjust wait time as needed
}
**/



# Setting up the Service Account for the Kubernetes Engine
module "kubernetes_service_account" {
  source = "./IAM_ADMIN/SERVICE_ACCOUNT"
  account_id = var.kubernetes_sa_account_id
  display_name = var.kubernetes_sa_display_name
  description = var.kubernetes_sa_description 
}

/**
output "kubernetes_service_account_email" {
    value = module.kubernetes_service_account.service_account_email
}
**/

# Setting up the IAM roles for the Service Account
module "IAM_for_kubernetes_sa" {
  source = "./IAM_ADMIN/IAM"
  for_each = toset(var.kubernetes_sa_roles)
  project_id = var.project_id
  member_role = each.value
  member = "serviceAccount:${module.kubernetes_service_account.service_account_email}"
  depends_on = [ module.kubernetes_service_account ]
}



#--------------------------------------------- Network Configuration ---------------------------------------------#

module "network" {
  source = "./VPC"

  network_name = var.network_name
  network_description = var.network_description 

  subnet_name        = var.subnet_name
  subnet_description = var.subnet_description
  ip_cidr_range = var.ip_cidr_range
  range_name = var.range_name
  ip_range = var.ip_range
  range_name_1 = var.range_name_1
  ip_range_1 = var.ip_range_1
  region = var.region

}

#g
/**
output "network_name" {
  value = module.network.network_name
}

output "subnet_name" {
  value = module.network.subnet_name
  
}

output "ip_cidr_range" {
  value = module.network.ip_cidr_range
}


output "range_name" {
  value = module.network.range_name
}

output "range_name_1" {
  value = module.network.range_name_1
}
**/


#--------------------------------------------- GKE Configuration ---------------------------------------------#

module "gke" {
  source = "./GKE"

  cluster_name = var.cluster_name
  cluster_region =  var.region
  #cluster_ipv4_cidr = module.network.ip_cidr_range
  cluster_description = var.cluster_description
  #default_max_pods_per_node = var.default_max_pods_per_node
  initial_node_count = var.initial_node_count

  network = "projects/${data.google_project.project.project_id}/global/networks/${module.network.network_name}"
  subnetwork = "projects/${data.google_project.project.project_id}/regions/${var.region}/subnetworks/${module.network.subnet_name}"

  workload_pool = "${data.google_project.project.project_id}.svc.id.goog"

  cluster_secondary_range_name = module.network.range_name
  services_secondary_range_name = module.network.range_name_1

  master_ipv4_cidr_block = var.master_ipv4_cidr_block

  master_access_cidr_block = var.master_access_cidr_block
  display_name = var.display_name

  depends_on = [ module.network ]
}


output "cluster_name" {
  value = module.gke.cluster_name
}


#--------------------------------------------- GKE Node Pool Configuration ---------------------------------------------#

module "gke_node_pool" {
  source = "./GKE_NODE_POOL"

  cluster_name = module.gke.cluster_name
  node_pool_name = var.node_pool_name
  node_pool_location = var.region
  project_id = data.google_project.project.project_id
  reg_node_location = var.reg_node_location
  max_pods_per_node = var.max_pods_per_node
  disk_size = var.disk_size
  disk_type = var.disk_type
  image_type = var.image_type
  pool_labels = var.pool_labels
  machine_type = var.machine_type
  node_service_account = module.kubernetes_service_account.service_account_email
  node_count = var.node_count
  min_node_count = var.min_node_count
  max_node_count = var.max_node_count

  depends_on = [ module.gke, module.network ] 
}

/**
output "cluster_endpoint" {
  value = module.gke.cluster_endpoint
  #sensitive = false
}


output "ca_certificate" {
  value = module.gke.ca_certificate
  sensitive = true
}
**/

#--------------------------------------------- Helm Configuration ---------------------------------------------#
data "google_client_config" "default" {}

/**
output "access_token" {
  value = data.google_client_config.default.access_token
  sensitive = true # Prevent the token from being displayed in the UI
}
**/


/**
resource "null_resource" "gke_credentials" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials beckn-cluster --region ${var.region} --project ${var.project_id}"
  }

  triggers = {
    cluster_name = module.gke.cluster_name
  }
}
**/

#--------------------------------------------- Kubernetes Provider Configuration ---------------------------------------------#

provider "kubernetes" {
  host = "https://${module.gke.cluster_endpoint}"
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  token = data.google_client_config.default.access_token
}

#--------------------------------------------- Router Configuration ---------------------------------------------#

module "router" {
  source = "./CLOUD_NAT/COMPUTE_ROUTER"
  router_name = var.router_name
  network_name = module.network.network_name
  router_description = var.router_description
  router_region = var.region

  depends_on = [ module.network ]
}

/**
output "router_name" {
  value = module.router.router_name
}
**/

#--------------------------------------------- Router NAT Configuration ---------------------------------------------#

module "router_nat" {
  source = "./CLOUD_NAT/COMPUTE_ROUTER_NAT"
  nat_name = var.nat_name
  router_name = module.router.router_name
  nat_region = var.region
  project_id = data.google_project.project.project_id
  depends_on = [ module.router, module.network ]
}

#--------------------------------------------- Helm Configuration ---------------------------------------------#

provider "helm" {
  kubernetes {
  host = "https://${module.gke.cluster_endpoint}"
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  token = data.google_client_config.default.access_token
  }
}

#--------------------------------------------- Helm Configuration ---------------------------------------------#

module "helm_config" {
  source = "./HELM/HELM_CONFIG"
  endpoint = "https://${module.gke.cluster_endpoint}"
  ca_certificate = base64decode(module.gke.ca_certificate)
  access_token = data.google_client_config.default.access_token
}

#--------------------------------------------- Nginx Ingress Configuration ---------------------------------------------#

module "nginx_namepsace"{
  source = "./NAMESPACE"
  namespace_name = var.nginix_namespace_name
  depends_on = [ module.gke, module.gke_node_pool]
}

#--------------------------------------------- Nginx Ingress Configuration ---------------------------------------------#

module "nginx_ingress" {
  source = "./HELM/HELM_RELEASES"
  helm_name = var.nginix_ingress_release_name
  helm_repository = var.nginix_ingress_repository
  helm_namespace = var.nginix_namespace_name
  helm_chart = var.nginix_ingress_chart
  helm_values = [
    file("./CONFIG_FILES/nginx.conf")
  ]
  depends_on = [ module.gke, module.gke_node_pool, module.helm_config, module.http_rule, module.http_firewall_rule, module.https-firewall-rule ]
}

#--------------------------------------------- Health Check Configuration ---------------------------------------------#

module "health_check" {
  source = "./HEALTH_CHECK"
  health_check_name = var.health_check_name
  health_check_description = var.health_check_description
  depends_on = [ module.network ]
}

/**
output "health_check_name" {
  value = module.health_check.health_check_name
}
**/

#--------------------------------------------- Backend Service Configuration ---------------------------------------------#

module "backend_service" {
  source = "./LOAD_BALANCER/BACKEND"
  backend_name = var.backend_service_name
  backend_description = var.backend_service_description
  group_1 = "projects/${data.google_project.project.project_id}/zones/${var.region}-a/networkEndpointGroups/ingress-nginx-01-internal-80-neg-http"
  group_2 = "projects/${data.google_project.project.project_id}/zones/${var.region}-b/networkEndpointGroups/ingress-nginx-01-internal-80-neg-http" 
  group_3 = "projects/${data.google_project.project.project_id}/zones/${var.region}-c/networkEndpointGroups/ingress-nginx-01-internal-80-neg-http"
  health_check = ["projects/${data.google_project.project.project_id}/global/healthChecks/${module.health_check.health_check_name}"]
  #security_policy = "projects/${var.project_id}/global/securityPolicies/default-security-policy-for-backend-service-${var.backend_service_name}"
  depends_on = [ module.gke, module.health_check, module.gke_node_pool, module.nginx_ingress ]
}

/**
output "backend_id" {
  value = module.backend_service.backend_id
}
**/

#--------------------------------------------- Firewall Configuration ---------------------------------------------#

#Health check
module "http_rule" {
  source = "./VPC/FIREWALL_ALLOW"
  firewall_name = var.http_firewall_name
  firewall_description = var.http_firewall_description
  vpc_network_name = module.network.network_name
  firewall_direction = var.http_firewall_direction
  allow_protocols = var.http_allow_protocols
  allow_ports = var.http_allow_ports
  source_ranges = var.source_ranges
  depends_on = [ module.network ]
}

#Allow traffic from internet
module "http_firewall_rule" {
  source = "./VPC/FIREWALL_ALLOW"
  firewall_name = var.allow_http_firewall_name
  firewall_description = var.allow_http_firewall_description
  vpc_network_name = module.network.network_name
  firewall_direction = var.allow_http_firewall_direction
  allow_protocols = var.allow_http_allow_protocols
  allow_ports = var.allow_http_allow_ports
  source_ranges = var.http_source_ranges
  depends_on = [ module.network ]
}

module "https-firewall-rule" {
  source = "./VPC/FIREWALL_ALLOW"
  firewall_name = var.allow_https_firewall_name
  firewall_description = var.allow_https_firewall_description
  vpc_network_name = module.network.network_name
  firewall_direction = var.allow_https_firewall_direction
  allow_protocols = var.allow_https_allow_protocols
  allow_ports = var.allow_https_allow_ports
  source_ranges = var.https_source_ranges
  depends_on = [ module.network ]
}



#--------------------------------------------- Global IP Configuration ---------------------------------------------#

module "lb_global_ip"{
  source = "./COMPUTE_ENGINE/GLOBAL_ADDRESS"
  global_ip_name = var.global_ip_name
  global_ip_description = var.global_ip_description
  global_ip_labels = var.global_ip_labels
}

/**
output "global_ip_address" {
  value = module.lb_global_ip.global_ip_address 
}
**/

#--------------------------------------------- URL Map Configuration ---------------------------------------------#

module "url_map" {
  source = "./LOAD_BALANCER/URL_MAP"
  url_map_name = var.url_map_name
  backend_service_id = module.backend_service.backend_id
  url_map_description = var.url_map_description
  depends_on = [ module.backend_service ]
}

/**
output "url_map" {
  value = module.url_map.url_map 
}
**/

#--------------------------------------------- Target Proxy Configuration ---------------------------------------------#

module "target_proxy" {
  source = "./LOAD_BALANCER/HTTP_PROXY"
  proxy_name = var.http_proxy_name
  url_map_id = module.url_map.url_map
  proxy_description = var.http_proxy_description
  depends_on = [ module.url_map ]
}

/**
output "target_http_proxy" {
  value = module.target_proxy.target_http_proxy
}
**/

#--------------------------------------------- Forwarding Rule Configuration ---------------------------------------------#

module "forwarding_rule" {
  source = "./LOAD_BALANCER/FRONTEND"
  frontend_name = var.frontend_name
  frontend_description = var.frontend_description
  frontend_ip = module.lb_global_ip.global_ip_address
  frontend_port = var.frontend_port
  target_proxy_id  = module.target_proxy.target_http_proxy
  
  depends_on = [ module.target_proxy, module.lb_global_ip ]
  
}

#--------------------------------------------- Pub Sub Topic Configuration ---------------------------------------------#

module "pub_sub_topic" {
    source = "./PUB_SUB/TOPIC"
    topic_name = var.topic_name
}

output "topic_name" {
  value = var.topic_name
}

#--------------------------------------------- Pub Sub Subscription Configuration ---------------------------------------------#
module "pub_sub_subscription" {
    source = "./PUB_SUB/SUBSCRIPTION"
    subscription_name = var.subscription_name
    topic_id = module.pub_sub_topic.topic_id
    labels = var.labels
    ack_deadline_seconds = var.ack_deadline_seconds
    message_retention_duration = var.message_retention_duration
    expiration_policy_ttl = var.expiration_policy_ttl
    depends_on = [ module.pub_sub_topic ]
    #retry_policy_minimum_backoff = var.retry_policy_minimum_backoff
    #retry_policy_maximum_backoff = var.retry_policy_maximum_backoff
}

output "subscription_name" {
  value = var.subscription_name
}

#--------------------------------------------- Redis API Configuration ---------------------------------------------#

/**
resource "google_project_service" "memorystore" {
  project = var.project_id # Replace with your project ID
  service = "redis.googleapis.com"

  disable_on_destroy = false
  lifecycle {
    prevent_destroy = true
  }
}



resource "time_sleep" "wait_for_redis" {
    depends_on = [ resource.google_project_service.memorystore ]
    create_duration = "120s"
}
**/



/**
resource "google_project_service" "private_service_access" {
  project = var.project_id  # Replace with your project ID
  service = "servicenetworking.googleapis.com"
}

resource "time_sleep" "wait_for_psa" {
    depends_on = [ resource.google_project_service.private_service_access ]
    create_duration = "120s"
}
**/

#--------------------------------------------- Private VPC Access Configuration ---------------------------------------------#

module "global_address" {
    source = "./VPC/GLOBAL_ADDRESS"
    vpc_peering_ip_name = var.vpc_peering_ip_name
    vpc_peering_ip_purpose = var.vpc_peering_ip_purpose
    vpc_peering_ip_address_type = var.vpc_peering_ip_address_type
    vpc_peering_ip_network = "projects/${data.google_project.project.project_id}/global/networks/${module.network.network_name}"
    vpc_peering_prefix_length = var.vpc_peering_prefix_length
    depends_on = [ module.network ]
}


resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = "projects/${data.google_project.project.project_id}/global/networks/${module.network.network_name}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [module.global_address.reserved_ip_range]

  depends_on = [ module.global_address, module.network ]
}

resource "time_sleep" "wait_for_ps_networking" {
  depends_on      = [google_service_networking_connection.private_vpc_connection]
  create_duration = "150s"
}

#--------------------------------------------- Redis Configuration ---------------------------------------------#

module "redis" {
    source = "./REDIS/REDIS_INSTANCE"
    instance_name = var.instance_name
    memory_size_gb = var.memory_size_gb
    instance_tier = var.instance_tier
    instance_region = var.instance_region
    instance_location_id = var.instance_location_id
    instance_authorized_network = "projects/${data.google_project.project.project_id}/global/networks/${module.network.network_name}"
    instance_connect_mode = var.instance_connect_mode
    depends_on = [ google_service_networking_connection.private_vpc_connection, module.global_address ]
}

output "redis_instance_ip" {
  value = module.redis.redis_instance_ip
  description = "The IP address of the created Redis instance"
}

#--------------------------------------------- Adapter Configuration ---------------------------------------------#

# Adapter Namespace

module "adapter_namespace"{
  source = "./NAMESPACE"
  namespace_name = var.adapter_namespace_name
  namespace_annotations = {
      "iam.gke.io/gcp-service-account" = module.bucket_sa.service_account_email
    }
  depends_on = [ module.gke, module.gke_node_pool] 
}

output "adapter_namespace_name" {
  value = var.adapter_namespace_name
}

# Adapter Namespace Service Account

module "adapter_ksa" {
  source = "./KUBERNETES_SA"
  ksa_name = var.adapter_ksa_name
  namespace = var.adapter_namespace_name
  annotations = {
      "iam.gke.io/gcp-service-account" = module.bucket_sa.service_account_email
    }
  depends_on = [ module.adapter_namespace, module.bucket_sa ]
}

output "namespace_sa_name" {
  value = var.adapter_ksa_name
}

# Bucket Service Account

module "bucket_sa" {
  source = "./IAM_ADMIN/SERVICE_ACCOUNT"
  account_id = var.bucket_sa_account_id
  display_name = var.bucket_sa_display_name
  description = var.bucket_sa_description
}


/**

output "bucket_sa_email" {
  value = module.bucket_sa.service_account_email
}

output "bucket_sa_id" {
  value = module.bucket_sa.service_account_id 
}

**/

# IAM Roles for Bucket Service Account

module "IAM_for_bucket_sa" {
  source = "./IAM_ADMIN/IAM"
  for_each = toset(var.bucket_sa_roles)
  project_id = var.project_id
  member_role = each.value
  member = "serviceAccount:${module.bucket_sa.service_account_email}"
  depends_on = [ module.bucket_sa ]
}


# Workload Identity Binding

resource "google_service_account_iam_binding" "workload_identity" {
  service_account_id = module.bucket_sa.service_account_id
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.adapter_namespace_name}/${var.adapter_ksa_name}]"
  ]
  depends_on = [ module.adapter_ksa, module.adapter_namespace ]
}


# Bucket for storing configurations

module "config_bucket" {
  source = "./CLOUD_STORAGE"
  bucket_name = var.config_bucket_name
  bucket_location = var.region
  depends_on = [ module.adapter_ksa, module.bucket_sa ]
}

output "config_bucket_name" {
  value = var.config_bucket_name
}


# IAM Roles for Adapter Bucket Access

resource "google_storage_bucket_iam_member" "adapter_bucket_access" {
  bucket = var.config_bucket_name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${module.bucket_sa.service_account_email}"
  depends_on = [ module.config_bucket ]
}

output "project_id" {
  value = var.project_id
}

output "cluster_region" {
  value = var.region
}
