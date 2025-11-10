provider "helm" {
  kubernetes {

    host                   = var.endpoint
    # Endpoint of the cluster

    token                  = var.access_token
    # Access token for the cluster

    cluster_ca_certificate = base64decode(var.ca_certificate)
    # CA certificate for the cluster

    #config_path = var.config_path
    # Path to the kubeconfig file

  }
}
