variable "health_check_name" {
    type = string
    description = "Health Check Name"
}

variable "health_check_description" {
    type = string
    description = "Description for the health check"
}

variable "request_path" {
    type = string
    description = "The request path of the HTTP health check request. The default value is /."
}

variable "health_check_port" {
    type = string
    description = "The TCP port number for the HTTP health check request. The default value is 80."
}