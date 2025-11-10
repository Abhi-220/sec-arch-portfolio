variable "bucket_name" {
    type = string
    description = "Name of your bucket"
}

variable "bucket_location" {
    type = string
    description = "Location for your bucket"
}

variable "bucket_storage_class" {
    type = string
    description = "Your bucket storgae class"
    default = "STANDARD"
}

variable "destroy_value" {
    type = bool
    description = "Whether to give terraform privilege to delete the bucket or not"
    default = false
}

variable "versioning_value" {
    type = bool
    description = "Whether to set object versioning or not"
    default = false
}

variable "bucket_labels" {
    type = map(string)
    description = "Labels for your bucket"
    default = {
      "name" = "beckn"
    }
}

variable "access_level" {
    type = bool
    description = "Whether to set uniform bucket level access or not"
    default = true
}