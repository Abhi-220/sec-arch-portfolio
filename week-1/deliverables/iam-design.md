# IAM Design — Secure GCP Foundation

## 1. Overview

This document defines the **Identity and Access Management (IAM)** design for a secure and scalable GCP foundation.  
It serves as the Week-1 deliverable under the **Security Architecture Mastery Path**, emphasizing:
- Least privilege principle
- Separation of duties
- Keyless authentication
- Centralized governance with distributed access

The design balances **security rigor** and **operational practicality**, following enterprise-grade GCP patterns.

---

## 2. Resource Hierarchy

Organization: my-org
│
├── Folder: Production
│ ├── Project: reaper-prod
│ ├── Project: chronos-prod
│ └── Project: prod-infra
│
├── Folder: Staging
│ ├── Project: reaper-stage
│ ├── Project: chronos-stage
│ └── Project: stage-infra
│
└── Folder: Shared-Services
├── Project: networking
├── Project: monitoring
└── Project: automatio



### Design Rationale
- **Environment-based folders** ensure strong policy and access segregation between prod, staging, and shared services.
- **Projects** group related workloads and budgets.
- **Folders** allow environment-wide IAM enforcement (e.g., "no dev access in prod").
- Policies inherit top-down but can be overridden at the project level for precision.

**Access governance:**  
Broad IAM (e.g., auditors, infra admins) applies at folder level;  
App-specific IAM applies at project level.  
This model reduces management overhead while maintaining isolation.

---

## 3. Role Design Strategy

IAM roles define *who can do what* at each layer.  
Two types exist — **predefined** and **custom** — each serving different control levels.

### Core Philosophy
> Use **predefined roles** by default at the **project level** for common operations.  
> Use **custom roles** sparingly — only when predefined roles are over-privileged or at organization scope.

### Comparative View

| Role Type | Use Case | Scope | Benefit | Risk |
|------------|-----------|--------|----------|------|
| **Predefined** | Common GCP operations (Compute, Storage, Cloud Run, Monitoring) | Project | Easy to use, auto-maintained | Overlap & tracking overhead |
| **Custom** | Precise least-privilege enforcement (Terraform, Org Security, Audit) | Org / Folder / Project | Fine-grained control | Operational complexity |

### Role Governance Rules
1. **Default to predefined** roles at project scope.  
2. **Custom roles require approval & versioning.**  
3. **All IAM managed via Terraform or GitOps** — no manual role grants.  
4. **Groups over users:** Assign to Workspace groups, not individuals.  
5. **Review quarterly:** Remove unused roles with IAM Recommender insights.

### Example Roles

| Persona | Role Type | Scope | Purpose |
|----------|------------|--------|----------|
| Terraform SA | Custom | Project | Provisioning limited resources (no org-level access) |
| Developers | Predefined | Project | Use Compute, Cloud Run, and Storage with limited scopes |
| Security Admins | Custom | Org | Manage SCC, IAM policy, and org constraints |
| Network Team | Predefined | Host Project | `roles/compute.networkAdmin` |
| Auditors | Predefined | Org/Folder | Read-only access to logs and SCC findings |

### Example Custom Role — Terraform Provisioner

{
  "title": "Terraform Provisioner v1",
  "description": "Least privilege set for Terraform automation.",
  "includedPermissions": [
    "compute.instances.create",
    "compute.instances.delete",
    "compute.instances.get",
    "compute.networks.get",
    "compute.subnetworks.get",
    "compute.firewalls.create",
    "storage.buckets.create",
    "storage.objects.create",
    "iam.serviceAccounts.actAs"
  ]
}

4. Service Account Architecture
Design Principles

Each Service Account (SA) represents a single machine identity.

No reuse across environments.

Follow one SA per function pattern (Terraform, runtime, monitoring, automation).

No static keys — all authentication is short-lived and auditable.

Service Account	Purpose	Scope	Authentication Method
tf-admin@infra-project.iam.gserviceaccount.com	Terraform provisioning	Project	Workload Identity Federation (WIF) / Impersonation
app-sa@apps-project.iam.gserviceaccount.com	Application runtime	Project	Attached to GCE / GKE / Cloud Run
monitor-sa@monitoring-project.iam.gserviceaccount.com	Monitoring + logging	Shared Services	Instance-attached SA
automation-sa@shared-services.iam.gserviceaccount.com	CI/CD automation	Shared Services	Cloud Build SA impersonation

Keyless Operation Patterns
4.1 Service Account Impersonation

Used within GCP (Cloud Build, GCE):

gcloud auth application-default login \
  --impersonate-service-account=tf-admin@infra-project.iam.gserviceaccount.com

Grants short-lived credentials via roles/iam.serviceAccountTokenCreator.

4.2 Workload Identity Federation (WIF)

Used from external CI/CD (GitHub, Jenkins):

permissions:
  id-token: write
steps:
  - name: Authenticate to GCP
    uses: google-github-actions/auth@v2
    with:
      workload_identity_provider: "projects/123456789/locations/global/workloadIdentityPools/github-pool/providers/github"
      service_account: "tf-admin@infra-project.iam.gserviceaccount.com"


Short-lived tokens → no key exposure.

4.3 Forbidden

Static JSON key files

Shared SAs between teams

Manually created keys outside automation

Detection & Alerting

Monitor key creation:

protoPayload.serviceName="iam.googleapis.com"
protoPayload.methodName="google.iam.admin.v1.CreateServiceAccountKey"

Trigger alert → Security team auto-review.

5. Access Model
Group / Identity	Scope	Typical Roles	Description
Org Admins	Org	roles/resourcemanager.organizationAdmin, roles/iam.securityAdmin	Full governance
Security Team	Org / Folder	roles/securitycenter.admin, custom roles	SCC, compliance
Infra Admins	Folder	roles/editor, network admin	Infra provisioning
Developers	Project	Limited predefined roles	Deploy & manage workloads
Auditors	Org	roles/viewer, roles/logging.viewer	Read-only audit
Service Accounts	Project	Custom least-privilege	Automation/runtime

Access Principles

Group-based IAM only.

Folders enforce environment isolation (Prod ≠ Stage).

No user has both provisioning and approval powers.

IAM changes flow through Terraform PRs with review.

6. Authentication & Key Management Policy
6.1 Approved Methods

Workload Identity Federation for external pipelines.

Service Account Impersonation for GCP-native runners.

SSO (OAuth 2.0) for admins.

6.2 Prohibited

Downloaded static keys.

Hard-coded credentials.

Shared service accounts.

6.3 Monitoring & Response

Cloud Audit Logs capture every IAM change.

Key creation alerts trigger auto-revocation workflow.

Logs routed to centralized SIEM / SCC.

7. Governance & Maintenance
Control	Frequency	Owner	Description
IAM Review	Quarterly	Security Team	Verify least privilege, remove stale bindings
Key Scan	Continuous	Security Bot	Detect key creation
Role Registry	Ongoing	Platform Team	Version and maintain custom roles in Git
Policy Simulator Tests	On-change	DevOps	Validate IAM before deploy

IAM Recommender is enabled on all projects for right-sizing.


8. Security Philosophy

“Access is not granted; it is earned, reviewed, and expired.”

IAM in this architecture is not static configuration — it’s a living, auditable control surface.

Every identity (human or service) is purposeful.

Every permission is justified and time-bounded.

Every change is traceable through logs and code review.

No permanent secrets exist in plain text anywhere.

This model aligns with Zero Trust and Google’s Cloud Adoption Framework: verify identity, limit privilege, and continuously audit.

9. Future Enhancements

Enforce Organization Policy Constraints (disable external SA keys, enforce domain-restricted sharing).

Integrate IAM Recommender API into CI pipelines for drift detection.

Implement Access Approval for sensitive org-level actions.

Adopt Policy Controller (OPA/Gatekeeper) for preventive IAM policy validation.

Expand Workload Identity Federation to all external systems.

Author: Abhishek
Track: Security Architect Mastery — Week-1 Deliverable
Document Path: week-1/deliverables/iam-design.md


---

✅ This single file now includes:
- Full hierarchy and rationale  
- Role design strategy (with your philosophy on predefined vs custom)  
- Complete service-account plan (with impersonation/WIF)  
- Authentication & key policy  
- Governance controls  
- Security architect philosophy  

Would you like me to also prepare the **Mermaid diagram block** (so you can paste it below this markdown) showing:  
`Org → Folders → Projects → SAs + IAM Flow (WIF + Impersonation)` — for visualization inside GitHub?



