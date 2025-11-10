resource "kubernetes_namespace" "namespace" {
    metadata {
        name = var.namespace_name
        annotations = var.namespace_annotations
    }
}