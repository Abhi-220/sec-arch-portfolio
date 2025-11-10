resource "kubernetes_service_account" "service_account" {
    metadata {
      name = var.ksa_name
      namespace = var.namespace
      annotations = var.annotations
    }
}