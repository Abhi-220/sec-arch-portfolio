project_id = "trusty-relic-370809"
region = "asia-south1"

kubernetes_sa_account_id = "onix-adapter-kubernetes-sa"
kubernetes_sa_display_name = "onix-adapter-kubernetes-sa"
kubernetes_sa_description = "Service Account for Beckn Kubernetes"


kubernetes_sa_roles = ["roles/redis.viewer",
  "roles/cloudtrace.agent",
  "roles/compute.instanceAdmin.v1",
  "roles/compute.networkAdmin",
  "roles/editor",
  "roles/container.admin",
  "roles/pubsub.admin",
  "roles/pubsub.publisher",
  "roles/pubsub.viewer",
  "roles/secretmanager.admin",
  "roles/secretmanager.secretAccessor",
  "roles/iam.serviceAccountAdmin",
  "roles/iam.serviceAccountTokenCreator", "roles/iam.securityAdmin", "roles/resourcemanager.projectIamAdmin"]


network_name = "onix-adapter-network"
network_description = "network for beckn"

subnet_name = "onix-adapter-gke-subnet"
subnet_description = "subnet for beckn gke"
ip_cidr_range = "10.0.0.0/17"
range_name = "onix-adapter-gke-pods"
ip_range = "10.0.128.0/21"
range_name_1 = "onix-adapter-gke-services"
ip_range_1 = "10.0.136.0/21"



cluster_name = "onix-adapter-cluster"
cluster_description = "cluster for onix adapter"
initial_node_count = "1"
master_ipv4_cidr_block = "172.0.0.16/28" #"172.0.0.16/28" #"172.0.0.0/28"
master_access_cidr_block = "0.0.0.0/0"
display_name = "beckn cluster access IPs"



node_pool_name = "onix-adapter-node-pool"
reg_node_location = [ "asia-south1-a", "asia-south1-b", "asia-south1-c" ]  
max_pods_per_node = "50"
disk_size = "50"
disk_type = "pd-standard"
image_type = "cos_containerd"
pool_labels = {
  service = "adapter"
}
machine_type = "e2-standard-2"
node_count = "1"
min_node_count = "1"
max_node_count = "2"

nginix_namespace_name = "ingress-nginx"

router_name = "onix-router-router"
router_description = "router for onix-adapter"

nat_name = "onix-adapter-nat"



nginix_ingress_release_name = "ingress-nginx"
nginix_ingress_repository = "https://kubernetes.github.io/ingress-nginx"
nginix_ingress_chart = "ingress-nginx"


health_check_name = "onix-adapter-health-check"
health_check_description = "health check for onix-adapter"


backend_service_name = "onix-adapter-backend-service"
backend_service_description = "backend service for onix adapter"


http_firewall_name = "onix-adapter-allow-health-http"
http_firewall_description = "allow http traffic for health check"
http_firewall_direction = "INGRESS"
http_allow_protocols = "tcp"
http_allow_ports = [80]
source_ranges = [ "35.191.0.0/16" ]

allow_http_firewall_name = "onix-adapter-allow-http"
allow_http_firewall_description = "allow http for onix adapter from internet"
allow_http_firewall_direction = "INGRESS"
allow_http_allow_protocols = "tcp"
allow_http_allow_ports = [ 80 ]
http_source_ranges = [ "0.0.0.0/0" ]


allow_https_firewall_name = "onix-adapter-allow-https"
allow_https_firewall_description = "allow https for beckn from internet"
allow_https_firewall_direction = "INGRESS"
allow_https_allow_protocols = "tcp"
allow_https_allow_ports = [ 443 ]
https_source_ranges = [ "0.0.0.0/0" ]

global_ip_name = "onix-adapter-global-lb-ip"
global_ip_description = "ip for onix adapter lb"
global_ip_labels = {
  "name" = "onix-adapter-lb-ip"
}


url_map_name = "onix-adapter-url-map"
url_map_description = "url map for onix adapter"


http_proxy_name = "onix-adapter-http-proxy"
http_proxy_description = "http proxy for onix adapter"


frontend_name = "onix-adapter-frontend"
frontend_description = "frontend for onix adapter"
frontend_port = "80"



topic_name = "bapNetworkReceiver-topic"

subscription_name = "bapNetworkReceiver-sub"
labels = {
  "service" = "adapter"
}
ack_deadline_seconds = "10"
message_retention_duration = "604800s"
expiration_policy_ttl = "2678400s"



vpc_peering_ip_name = "onix-adapter-vpc-peering"
vpc_peering_ip_purpose = "VPC_PEERING"
vpc_peering_ip_address_type = "INTERNAL"
vpc_peering_prefix_length = "24"


instance_name = "onix-adapter-redis-instance"
memory_size_gb = "1"
instance_tier = "BASIC"
instance_region = "asia-south1"
instance_location_id = "asia-south1-a"
instance_connect_mode = "PRIVATE_SERVICE_ACCESS"

adapter_namespace_name = "onix-adapter"

adapter_ksa_name = "onix-adapter-ksa"

bucket_sa_account_id = "onix-adapter-bucket-sa"
bucket_sa_display_name = "onix-adapter-bucket-sa"
bucket_sa_description = "Service Account for Onix Adapter Bucket"


bucket_sa_roles = [ "roles/storage.admin", "roles/cloudtrace.agent", "roles/pubsub.admin", "roles/pubsub.publisher", "roles/secretmanager.admin", "roles/secretmanager.secretAccessor" ]

config_bucket_name = "onix-adapter-config-bucket"
