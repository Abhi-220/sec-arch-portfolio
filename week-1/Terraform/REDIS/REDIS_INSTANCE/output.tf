output "redis_instance_ip" {
  value = google_redis_instance.instance.host
  description = "The IP address of the created Redis instance"
}
