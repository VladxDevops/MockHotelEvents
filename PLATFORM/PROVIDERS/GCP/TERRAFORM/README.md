+++
title = "PLATFORM / PROVIDERS / GCP / TERRAFORM Index"
domain = "infrastructure"
topics = ["terraform", "gcp", "infrastructure", "gitops", "index"]
difficulty = "advanced"
progressive_tier = "Tier 3"
parent = "PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md"
children = ["PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md", "PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md"]
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md",
    "APPS/REDIS/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`cloud-infrastructure-checklist.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`cloud-infrastructure-checklist.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Documents Terraform and Google Cloud infrastructure needed to run the mock Hotel Events platform.
- Questions Answered: What GCP and Terraform resources are needed, and how should environments be provisioned?
- When to Retrieve: Working on infrastructure context for the Hotel Events wedding inquiry platform.
- When NOT to Retrieve: Working on unrelated generated assets, dependency lockfiles, or implementation code that does not need documentation context.
-->
# PLATFORM / PROVIDERS / GCP / TERRAFORM Index

This directory index routes maintainers and AI agents to the local documentation in `PLATFORM/PROVIDERS/GCP/TERRAFORM` without loading unrelated repository context.

## Contents

| File | Tier | Primary Topic |
| :--- | :---: | :--- |
| `cloud-infrastructure-checklist.md` | Tier 3 | Cloud Infrastructure Checklist for the Current Project |
| `dev-environment-starter-architecture.md` | Tier 3 | Starter Terraform / GCP Dev Architecture Plan |
| `terragrunt.md` | Tier 3 | Terragrunt Installation and Usage for Multi-Environment Delivery |
| `folder-structure.md` | Tier 3 | Exact Folder Layout and Responsibility Definitions |

## Dependencies & Upstream Services

Start from `Agents.md` and `DOCUMENTATION/INTERNAL/spects.md` for the canonical Hotel Events flow. Load only the listed local files that match the task domain.

## Recommended Reading Order

1. `Agents.md`
2. `DOCUMENTATION/INTERNAL/spects.md`
3. This directory index
4. The specific file needed for the current task

## Terragrunt

Terragrunt is a recommended wrapper around Terraform for this repo’s multi-environment GCP design.

It helps manage:
- shared Terraform defaults
- environment-specific overrides
- remote state configuration
- GitOps-friendly environment promotion
- CI/CD validation and deployment flows

For the repository’s current design, Terragrunt is best used as:
- a layer above reusable Terraform modules
- a pattern for DEV, TEST, STAGING, and PROD
- a way to keep infrastructure consistent across environments

See:
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md`

## Apigee X (Evaluation) Architecture & Deployment

This directory contains a complete, MVP-ready Terraform codebase for provisioning Apigee X (Evaluation) from scratch on Google Cloud Platform.

### Core Architecture Components
1. **Dynamic Project Provisioning**: Conditionally provisions `google_project` or binds to an existing GCP project.
2. **Service Enablement**: Enables `apigee.googleapis.com`, `compute.googleapis.com`, `servicenetworking.googleapis.com`, and `cloudresourcemanager.googleapis.com` with propagation buffers (`time_sleep`).
3. **Dedicated VPC Network**:
   - `apigee-vpc` with custom subnetting.
   - `apigee-subnet` (`10.100.0.0/24`) with Private Google Access.
   - `apigee-proxy-only-subnet` (`10.100.1.0/24`, `purpose = "REGIONAL_MANAGED_PROXY"`).
4. **Private Service Access (PSA)**:
   - Reserved `/22` IP allocation for Apigee runtime (`google_compute_global_address`).
   - Service Networking peering connection (`google_service_networking_connection`).
5. **Apigee X Evaluation Model**:
   - Apigee Organization (`billing_type = "EVALUATION"`, no CMEK requirement).
   - Apigee Instance in `us-central1`.
   - Environment `dev` + Environment Group `dev-env-group`.
   - Environment and Instance attachments.
6. **Northbound Ingress (L7 Load Balancer)**:
   - Private Service Connect (PSC) NEG (`google_compute_region_network_endpoint_group`).
   - Global External Application Load Balancer (`EXTERNAL_MANAGED`).
   - Dual frontends: HTTP (Port 80) and HTTPS (Port 443 with self-signed certificate).
7. **Sample Proxy & Verification**:
   - Bundled mock hotel events proxy (`sample-proxy/mock-hotel-events.zip`).
   - Automated deployment helper (`deploy-proxy.sh`).
   - Automated curl smoke test script (`test-apigee.sh`).

### Quick Start

```bash
# 1. Initialize Terraform
terraform init

# 2. Inspect the Execution Plan
terraform plan -var-file=dev.tfvars

# 3. Apply to GCP
terraform apply -var-file=dev.tfvars

# 4. Run Smoke Tests
./test-apigee.sh --all
```

