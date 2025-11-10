variable "frontend_name" {
    type = string
    description = "Name of the forwarding rule"
}

variable "frontend_description" {
    type = string
    description = "Description of the forwarding rule"
}

variable "frontend_ip" {
    type = string
    description = "Reserved Static or Interval #Enter the 'global_address' link or IP of existing static IP"
}

variable "target_proxy_id" {
    type = string
    description = "Target HTTP Proxy for the forwarding rule"
}

variable "frontend_port" {
    type = string
    description = "Port range for the forwarding rule"
}