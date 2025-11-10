resource "helm_release" "release" {
    name = var.helm_name
    repository = var.helm_repository
    namespace = var.helm_namespace
    chart = var.helm_chart
    version = var.helm_version
    timeout = var.timeout
    values = var.helm_values
}