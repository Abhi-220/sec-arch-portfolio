# This variable block is for Project IAM Binding

variable "project_id" {
    type = string
    description = "The project id"
}

/**
variable "role" {
    type = string
    description = "The role to be assigned"
}

variable "members" {
    type = list(string)
    description = "List of members that needs to be assigned the role"
}
**/

# This variable block is for Project IAM Member

variable "member_role" {
    type = string
    description = "The role to be assigned"
}

variable "member" {
    type = string
    description = "Member that needs to be assigned the role"
}