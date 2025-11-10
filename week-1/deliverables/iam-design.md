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

### Example Custom Role Snippet — Terraform Provisioner
```json
{
  "title": "Terraform Provisioner v1",
  "description": "Minimal permissions for Terraform automation",
  "includedPermissions": [
    "compute.instances.create",
    "compute.instances.delete",
    "compute.networks.get",
    "compute.subnetworks.get",
    "compute.firewalls.create",
    "storage.buckets.create",
    "iam.serviceAccounts.actAs"
  ]
}


4. Service Account Design
Principle

Each Service Account (SA) represents a machine identity, following least-privilege and single-purpose usage.

Service Account	Purpose	Scope	Notes
tf-admin@infra-project.iam.gserviceaccount.com	Terraform provisioning	Project	Used via impersonation or WIF; no static key
app-sa@apps-project.iam.gserviceaccount.com	Application runtime	Project	Limited to secrets, logging, and GCS
monitor-sa@monitoring-project.iam.gserviceaccount.com	Monitoring & logging	Shared Services	MetricWriter + LogWriter
automation-sa@shared-services.iam.gserviceaccount.com	CI/CD automation	Shared Services	Used by Cloud Build or GitHub Actions via WIF
Security Controls

No static keys. JSON keys are prohibited unless justified and tracked.

Impersonation and federation only.

Internal runners (Cloud Build, GCE) use Service Account Impersonation (roles/iam.serviceAccountTokenCreator).

External CI/CD (GitHub, Jenkins) use Workload Identity Federation (WIF) for keyless auth.

Dedicated service accounts per function — no reuse across environments.

Example WIF Policy

Terraform in GitHub Actions:

permissions:
  id-token: write
  contents: read
steps:
  - name: "Authenticate to GCP"
    uses: google-github-actions/auth@v2
    with:
      workload_identity_provider: "projects/123456789/locations/global/workloadIdentityPools/github-pool/providers/github"
      service_account: "tf-admin@infra-project.iam.gserviceaccount.com"


Result → short-lived token; no permanent key exposure.

5. Access Model
Group / Identity	Scope	Typical Roles	Description
Org Admins	Org	roles/resourcemanager.organizationAdmin, roles/iam.securityAdmin	Full governance control
Security Team	Org / Folder	roles/securitycenter.admin, custom security roles	Posture management & compliance
Infra Admins	Folder (Prod/Staging)	roles/editor, network admin	Build and maintain resources
Developers	Project	Custom or predefined deploy roles	Limited access to own projects
Auditors	Org	roles/viewer, roles/logging.viewer	Read-only monitoring & compliance
Service Accounts	Project	Custom least-privilege	Machine access for automation

Principles enforced:

Role separation: No single user can provision and approve.

Group-based IAM: Users join IAM groups, not direct bindings.

Folder-level policy boundaries: Prod isolation enforced via IAM conditions.



6. Authentication & Key Management
6.1 Allowed Authentication Methods

Workload Identity Federation (WIF) for external automation.

Service Account Impersonation for internal tools (Cloud Build, GCE).

OAuth 2.0 User Authentication for administrators via SSO.

6.2 Forbidden Practices

Static JSON keys for Terraform or automation.

Shared service accounts between users or pipelines.

Long-lived credentials without rotation.

6.3 Monitoring

Cloud Logging Filter for key creation:

protoPayload.serviceName="iam.googleapis.com"
protoPayload.methodName="google.iam.admin.v1.CreateServiceAccountKey"

→ Alerts security team on new key creation.

7. Governance & Review
Control	Frequency	Owner	Description
IAM Audit Review	Quarterly	Security Team	Review role bindings and unused permissions
Key Scan	Continuous	Security Bot	Detect static key creation via logs
Role Registry	Ongoing	Platform Team	Maintain versioned custom roles in Git
Policy Simulator Tests	On-demand	DevOps	Validate IAM changes pre-deployment

Versioning convention:
custom.RoleName_v1, increment on permission change.


8. Security Architecture Philosophy

"Access is not granted; it is earned, reviewed, and expired."

This IAM framework follows a Zero Trust mindset:

Every permission must be provable and auditable.

No long-lived secrets, no broad editor roles.

Every actor (human or machine) has an identity, a purpose, and a boundary.

The architecture combines:

Environment-level segregation (folder hierarchy),

Least privilege access (custom/predefined mix),

Keyless operations (impersonation/WIF),

Audit-driven governance.

This forms the IAM baseline for a secure, scalable, and audit-ready GCP environment.


Author: Abhishek
Track: Security Architect Mastery — Week 1 Deliverable
Document: week-1/deliverables/iam-design.md



---

### 🧠 Notes:
This version:
- Includes your stance on **predefined vs custom roles** (simplicity + security balance).  
- Integrates **service account impersonation & WIF** to eliminate key-based access.  
- Keeps hierarchy **environment-first**, respecting your reasoning.  
- Embeds security philosophy befitting a future **Security Architect God** 🛡️  

Would you like me to generate a **matching diagram** (Mermaid or PNG) showing:
`Org → Folders → Projects → SAs → IAM Flow (WIF + Impersonation)`  
so that your `iam-design.md` becomes a visually complete deliverable?

