variable "helm_name" {
    type = string
    description = "The name of the Helm release"
}


variable "helm_repository" {
    type = string
    description = "The Helm repository to use"
    default = ""
}


variable "helm_namespace" {
    type = string
    description = "The namespace to deploy the Helm release to"
}

variable "helm_chart" {
    type = string
    description = "The Helm chart to deploy"
    default = ""
}

variable "helm_version" {
    type = string
    description = "The version of the Helm chart to deploy"
    default = ""
}

variable "timeout" {
    type = string
    description = "The timeout for the Helm release"
    default = "600"
}

variable "helm_values" {
    type = any
    description = "The values to pass to the Helm chart"
    default = []
}