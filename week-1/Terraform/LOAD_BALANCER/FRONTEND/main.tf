resource "google_compute_global_forwarding_rule" "forwarding_rule" {
  name = var.frontend_name  
  # Name of the forwarding rule
  
  description = var.frontend_description  
  # Description of the forwarding rule

  ip_address = var.frontend_ip  
  #Reserved Static or Interval #Enter the "global_address" link or IP of existing static IP
  
  target = var.target_proxy_id
  # Target HTTP Proxy for the forwarding rule

  port_range = var.frontend_port  #  "80"  Frontend IP for your LB
    # Port range for the forwarding rule
}