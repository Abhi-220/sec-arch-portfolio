resource "google_storage_bucket" "bucket" {
    name = var.bucket_name   
    #Name of your bucket (Required)
    
    location = var.bucket_location  
    #Location of your bucket (Required)
    
    storage_class = var.bucket_storage_class  
    #(Optional, Default: 'STANDARD') The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE.
    
    force_destroy = var.destroy_value # (Optional, Default: false) When deleting a bucket, this boolean option will delete all contained objects.
                                      # If you try to delete a bucket that contains objects, Terraform will fail that run.

    versioning {
      enabled = var.versioning_value  #While set to true, versioning is fully enabled for this bucket.
    }

    labels = var.bucket_labels

    uniform_bucket_level_access = var.access_level

}