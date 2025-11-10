# Week 1 — Foundation: IAM, Network & Terraform

### 🎯 Objective
Establish a secure foundation with IAM principles, basic Terraform automation, and VPC segmentation.

### 🧰 Tasks
1. Set up your GCP project and service account.
2. Write Terraform code to:
   - Create a custom VPC
   - Add subnets (public/private)
   - Deploy one compute instance
3. Implement IAM roles for least privilege.
4. Document:
   - IAM hierarchy (org, project, resource)
   - Network design diagram
   - Security considerations

### 📦 Deliverables
- `terraform/main.tf`
- `deliverables/iam-design.md`
- `deliverables/network-plan.md`
- `architecture-diagram.drawio`

### 🧠 Review Questions
- Why is project-level IAM better than primitive roles?
- How does service account impersonation reduce key exposure?
- What’s the purpose of subnet segmentation in security?

---

✅ **End Goal:**  
You’ll have a working Terraform script that provisions an isolated, IAM-controlled environment and understand the foundation of security-by-design.
