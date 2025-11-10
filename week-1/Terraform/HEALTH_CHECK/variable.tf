variable "health_check_name" {
    type = string
    default = "health-check"
}

variable "health_check_description" {
    type = string
    default = "Health check for the instance group"
}

variable "request_path" {
    type = string
    default = "/healthz"
}

variable "health_check_port" {
    type = number
    default = 80
}