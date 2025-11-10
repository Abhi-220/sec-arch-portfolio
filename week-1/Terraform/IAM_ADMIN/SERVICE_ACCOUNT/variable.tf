variable "account_id" {
    type        = string
    description = "The account id that is used to generate the service account email address and a stable unique id."
}

variable "display_name" {
    type        = string
    description = "A user-specified display name of the service account."
}

variable "description" {
    type        = string
    description = "A user-specified description of the service account."
}

variable "create_ignore_already_exists" {
    type        = bool
    description = "If set to true, the service account will be created if it does not exist. If set to false, the resource will not be created if it does not exist."
    default     = false
}

