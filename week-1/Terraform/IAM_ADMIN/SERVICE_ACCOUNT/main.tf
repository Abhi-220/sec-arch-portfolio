resource "google_service_account" "service_account" {
    account_id = var.account_id
    # The account id that is used to generate the service account email address and a stable unique id.

    display_name = var.display_name
    # A user-specified display name of the service account.

    description = var.description
    # A user-specified description of the service account.

    create_ignore_already_exists = var.create_ignore_already_exists
    # If set to true, the service account will be created if it does not exist. If set to false, the resource will not be created if it does not exist.
    # Default is false.
}

