variable "ksa_name" {
    type = string
    description = "The name of the Kubernetes Service Account"
}

variable "namespace" {
    type = string
    description = "The namespace in which the Kubernetes Service Account will be created"
}

variable "annotations" {
    type = any
    description = "The annotations to apply to the Kubernetes Service Account"
    default = {}
}