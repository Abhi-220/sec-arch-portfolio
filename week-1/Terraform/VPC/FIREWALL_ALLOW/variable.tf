variable "firewall_name" {
    description = "Name of the firewall rule"
    type        = string
}

variable "firewall_description" {
    description = "Description of the firewall rule"
    type        = string
}

variable "vpc_network_name" {
    description = "Name or self-link of the VPC network to which this rule applies"
    type        = string
}

variable "rule_priority" {
    description = "Priority of the rule"
    type        = number
    default     = 1000
}

variable "firewall_direction" {
    description = "Direction of traffic"
    type        = string  
}

variable "log_metadata" {
    description = "Metadata to include in logs"
    type        = string
    default     = "INCLUDE_ALL_METADATA"
}

variable "allow_protocols" {
    description = "Protocol to allow"
    type        = string
}

variable "allow_ports" {
    description = "List of ports to allow"
    type        = list(number)
    default     = []
}

/**
variable "denied_protocols" {
    description = "Protocol to deny"
    type        = string
    default     = ""
}

variable "denied_ports" {
    description = "List of ports to deny"
    type        = list(number)
    default     = []
}


variable "target_service_accounts" {
    description = "Target service accounts for the rule"
    type        = list(string)
    default     = []
}

variable "target_tags" {
    description = "Target tags for the rule"
    type        = list(string)
    default     = []
}
**/

variable "source_ranges" {
    description = "List of IP ranges in CIDR format that the rule applies to"
    type        = list(string)
    default     = []
}

/**
variable "source_tags" {
    description = "List of instance tags that the rule applies to"
    type        = list(string)
    default     = []
}

variable "source_service_accounts" {
    description = "List of service accounts that the rule applies to"
    type        = list(string)
    default     = []
}

variable "destination_ranges" {
    description = "List of IP ranges in CIDR format that the rule applies to"
    type        = list(string)
    default     = []
  
}
**/