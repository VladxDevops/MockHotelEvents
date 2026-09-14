+++
title = "Terragrunt for GCP Multi-Environment Delivery"
domain = "infrastructure"
topics = ["terragrunt", "terraform", "gcp", "infrastructure", "gitops", "ci-cd"]
difficulty = "advanced"
progressive_tier = "Tier 3"
parent = "PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md"
children = []
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`cloud-infrastructure-checklist.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`dev-environment-starter-architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Documents how Terragrunt can be used to manage the DEV/TEST/STAGING/PROD environment model for the Hotel Events platform.
- Questions Answered: What is Terragrunt, how do we install it, and how do we use it in CI/CD for GCP?
- When to Retrieve: Working on infrastructure delivery patterns in the repo.
- When NOT to Retrieve: Working on runtime application code or data model examples.
-->

# Terragrunt for GCP Multi-Environment Delivery

## Purpose

> Status: Pending / Not started
>
> The pipeline automation, GitOps controller setup, and CI/CD integration described below are planned but not yet implemented in this repository. This document reflects the target delivery model rather than an active deployment workflow.

This document explains how Terragrunt can fit into the Hotel Events project as a thin orchestration layer over Terraform. It supports the repository’s current architecture goals:

- DEV-first infrastructure delivery
- repeatable environment patterns
- GitOps-friendly workflows
- consistent GCP provider and backend configuration
- cleaner promotion from DEV to TEST to STAGING to PROD

Terragrunt is not a replacement for Terraform. It is a wrapper that reduces repetition, standardizes environment configuration, and makes multi-environment infrastructure easier to manage.

## Why Terragrunt fits this project

This repository already models a realistic multi-environment deployment approach:

- DEV for development and iteration
- TEST for validation and regression checks
- STAGING for near-production readiness
- PROD for approved release paths

Terragrunt is useful here because the project will likely have repeated Terraform configuration across those environments. It helps centralize:

- remote state configuration
- provider settings
- environment-level variable overrides
- reusable input defaults
- layered configuration and inheritance

In short, Terraform defines the cloud resources, while Terragrunt defines how those resources are organized across environments.

## Recommended repo pattern

This is the recommended documentation-only shape for the project, without creating active IaC yet.

```text
PLATFORM/
  PROVIDERS/
    GCP/
      TERRAFORM/
        README.md
        cloud-infrastructure-checklist.md
        dev-environment-starter-architecture.md
        terragrunt.md
      live/
        dev/
        test/
        staging/
        prod/
      modules/
        network/
        iam/
        pubsub/
        redis/
        monitoring/
        cloudrun/
        gitops/
      terragrunt.hcl
      account.hcl
      region.hcl
```

### Interpretation

- `modules/` contains reusable Terraform modules
- `live/` contains environment-specific Terragrunt folders
- `terragrunt.hcl` contains shared defaults and inheritance
- `account.hcl` and `region.hcl` contain reusable account or region conventions
- each environment folder defines only the values that differ from the default

This architecture supports environment-specific overrides without copying a full Terraform stack repeatedly.

## Terragrunt installation

Terragrunt depends on Terraform being installed first.

### Prerequisites

- Terraform installed and on the PATH
- access to a GCP project or service account
- a Git repository with environment-based branching or promotion flow

### macOS

```bash
brew install terragrunt
terragrunt --version
```

### Linux (manual binary install)

```bash
curl -fsSL https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64 \
  -o /usr/local/bin/terragrunt

chmod +x /usr/local/bin/terragrunt
terragrunt --version
```

### Verify installation

```bash
terraform version
terragrunt --version
```

### Recommended local setup

For local developer work, install:

- Terraform
- Terragrunt
- gcloud CLI
- a GCP service account with the correct IAM roles
- a remote backend bucket for Terraform state

This is especially important for the DEV environment before promoting to higher tiers.

## Basic usage model

Terragrunt is generally used to run Terraform commands through a Terragrunt invocation.

Typical local flow:

```bash
cd PLATFORM/PROVIDERS/GCP/live/dev
terragrunt init
terragrunt plan
terragrunt apply
```

For a shared multi-environment setup, the best pattern is:

- create one common root config
- override environment values per folder
- keep Terraform modules in a reusable library
- use environment folders for DEV, TEST, STAGING, and PROD

### Operational benefits

- fewer duplicated Terraform blocks
- consistency between environments
- easier state handling
- cleaner promotion flow
- easier GitOps adoption

## How Terragrunt fits into CI/CD

Terragrunt is especially valuable in CI because it makes environment promotion explicit and predictable.

### Recommended CI workflow

1. PR validation
   - run `terragrunt hclfmt --terragrunt-check`
   - run `terragrunt run-all plan --terragrunt-non-interactive`
   - validate no drift or breaking changes to shared modules

2. Merge to main
   - trigger a controlled deployment workflow

3. Environment promotion
   - DEV: auto-deploy from a feature branch or merge path
   - TEST: deploy after DEV validation
   - STAGING: deploy after test pass
   - PROD: deploy only after approval gate

### CI responsibilities

A CI pipeline should handle:

- Terraform and Terragrunt installation
- GCP authentication
- environment selection
- remote state access
- plan generation
- approval or release gate
- apply only for allowed environments

### Example CI pattern

This is an example of the command flow, not a repo implementation yet:

```bash
# install tools
terraform version
terragrunt --version

# authenticate to GCP
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
gcloud config set project $GCP_PROJECT_ID

# validate / plan
terragrunt run-all plan --terragrunt-non-interactive

# apply only in approved environments
terragrunt run-all apply --terragrunt-non-interactive
```

### GitHub Actions example flow

Use a workflow that:

- runs on pull request for Terraform changes
- generates a plan for DEV
- requires approval before apply to any higher environment
- deploys to TEST/STAGING/PROD only from a controlled branch or release flow

For this project, a GitOps-friendly model is recommended:
- App and infrastructure definitions live in Git
- Git is the source of truth
- CI validates proposed Terraform/Terragrunt changes
- Argo CD or Flux reconciles the actual environment state

## GCP-specific recommendations

For this repository’s architecture, the following are the most relevant Terragrunt-driven infrastructure concerns:

- environment-specific project IDs
- region and zone configuration
- service account and IAM bindings
- VPC and subnet configuration
- Pub/Sub topics and subscriptions
- Redis / Memorystore instance sizing
- Cloud Run or containerized app service settings
- logging, monitoring, and alert rules
- secrets and secure configuration management

These should remain environment-aware and environment-isolated even when the underlying Terraform modules are shared.

## Security requirements

Terragrunt does not remove the need for proper security controls. The project should still enforce:

- least-privilege IAM
- separate credentials per environment
- secret handling via Secret Manager
- state backend access controls
- protected apply flows for higher environments
- no broad public exposure of internal services
- restricted CI permissions

## Recommended governance model

For this repository, a sensible policy is:

- DEV: developers can plan and apply with controls
- TEST: validation-focused environment with tighter controls
- STAGING: release-readiness gate before production
- PROD: manual approval required and audit-friendly

This keeps the deployment story realistic while staying aligned to the project’s mock enterprise hospitality architecture.

## Decision summary

Terragrunt is a good fit for this repo if the goal is to manage multiple environments without repeating Terraform blocks. It makes sense for:

- GCP infrastructure
- GitOps adoption
- environment promotion
- consistent configuration layering
- cleaner CI/CD execution

However, because the project is still in a design-first phase, the implementation should remain documentation-first until the core module structure and environment boundaries are clearly settled.

## Next steps

1. Define the shared Terraform modules for networking, IAM, messaging, cache, and monitoring.
2. Create the environment folders for DEV, TEST, STAGING, and PROD.
3. Add an environment-level Terragrunt root configuration.
4. Add CI workflows that validate Terraform/Terragrunt plans before apply.
5. Promote from DEV to TEST to STAGING to PROD in a controlled sequence.

This gives the repo a realistic, interview-ready infrastructure story without prematurely building production-grade IaC.
