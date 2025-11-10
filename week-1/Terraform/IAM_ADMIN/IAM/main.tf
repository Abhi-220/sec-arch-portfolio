/**
resource "google_project_iam_binding" "project" {
    project = var.project_id
    role = var.role

    members = var.members
    # List of members that needs to be assigned the role
}
**/



resource "google_project_iam_member" "project" {
    project = var.project_id
    role = var.member_role

    member = var.member
    # Member that needs to be assigned the role
  
}