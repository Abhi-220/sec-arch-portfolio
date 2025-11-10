variable "subscription_name" {
    type = string
    description = "The name of the subscription"
}

variable "topic_id" {
    type = string
    description = "The name of the topic from which this subscription is receiving messages"
}

variable "labels" {
    type = map(string)
    description = "A set of key/value label pairs to assign to this subscription"
}

variable "ack_deadline_seconds" {
    type = string
    description = "The maximum time after a subscriber receives a message before the subscriber should acknowledge the message"
}

variable "message_retention_duration" {
    type = string
    description = "How long to retain unacknowledged messages in the subscription's backlog, from the moment a message is published"
}

variable "expiration_policy_ttl" {
    type = string
    description = "Specifies the policy for controlling message expiration"
}

/**
variable "retry_policy_minimum_backoff" {
    type = string
    description = "Minimum delay between redelivery attempts"
}

variable "retry_policy_maximum_backoff" {
    type = string
    description = "Maximum delay between redelivery attempts"
}
**/

