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
