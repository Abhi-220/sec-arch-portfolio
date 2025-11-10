variable "namespace_name" {
    type        = string
    description = "The name of the namespace to create"
}

variable "namespace_annotations" {
    type = any
    description = "The annotations to apply to the namespace"
    default = {}
}