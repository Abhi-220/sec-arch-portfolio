resource "google_pubsub_subscription" "name" {

    name = var.subscription_name
    # The name of the subscription
    
    topic = var.topic_id
    # The name of the topic from which this subscription is receiving messages

    labels = var.labels
    # A set of key/value label pairs to assign to this subscription

    ack_deadline_seconds = var.ack_deadline_seconds
    # The maximum time after a subscriber receives a message before the subscriber should acknowledge the message

    message_retention_duration = var.message_retention_duration
    # How long to retain unacknowledged messages in the subscription's backlog, from the moment a message is published

    expiration_policy {
        ttl = var.expiration_policy_ttl
        # Specifies the policy for controlling message expiration
    }

/**
    retry_policy {

      minimum_backoff = var.retry_policy_minimum_backoff
      # Minimum delay between redelivery attempts

      maximum_backoff = var.retry_policy_maximum_backoff
      # Maximum delay between redelivery attempts
      
    }
**/    
}