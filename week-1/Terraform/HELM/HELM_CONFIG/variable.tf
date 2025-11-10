variable "endpoint" {
    type = string
    description = "The endpoint of the cluster"
}

variable "access_token" {
    type = string
    description = "The access token for the cluster"
}

variable "ca_certificate" {
    type = string
    description = "The CA certificate for the cluster"
}

/**
variable "config_path" {
    type = any
    description = "The path to the kubeconfig file"
}
**/