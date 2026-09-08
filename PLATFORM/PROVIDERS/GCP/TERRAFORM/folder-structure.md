+++
title = "Terragrunt Folder Structure Design for Hotel Events"
domain = "infrastructure"
topics = ["terragrunt", "terraform", "gcp", "infrastructure", "folder-structure", "environment-management"]
difficulty = "advanced"
progressive_tier = "Tier 3"
parent = "PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md"
children = []
related = [
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`terragrunt.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md)  
> **Related**: [`terragrunt.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md) | [`cloud-infrastructure-checklist.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md) | [`dev-environment-starter-architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Defines the exact directory layout and responsibilities for Terragrunt and Terraform organization in this repo.
- Questions Answered: What is the directory structure for live environments, shared modules, and configuration inheritance?
- When to Retrieve: Planning or implementing the Terragrunt folder structure for multi-environment deployment.
- When NOT to Retrieve: Working on application code or non-infrastructure topics.
-->

# Terragrunt Folder Structure Design for Hotel Events

## Purpose

This document defines the exact folder structure and responsibilities for the Hotel Events project using Terragrunt to manage Terraform across DEV, TEST, STAGING, and PROD environments.

This is a documentation-only specification. It does not include actual Terraform or Terragrunt configuration code, only folder organization and high-level responsibility definitions.

## Overall structure

```text
PLATFORM/
  PROVIDERS/
    GCP/
      README.md
      TERRAFORM/
        README.md
        cloud-infrastructure-checklist.md
        dev-environment-starter-architecture.md
        terragrunt.md
        folder-structure.md
      live/
        terragrunt.hcl                    # Root config with common settings
        account.hcl                       # GCP project and account conventions
        region.hcl                        # Region and zone defaults
        dev/
          terragrunt.hcl
          region.hcl
          README.md
          network/
            terragrunt.hcl
          iam/
            terragrunt.hcl
          messaging/
            terragrunt.hcl
          cache/
            terragrunt.hcl
          monitoring/
            terragrunt.hcl
          cloudrun/
            terragrunt.hcl
          gitops/
            terragrunt.hcl
        test/
          terragrunt.hcl
          region.hcl
          README.md
          network/
            terragrunt.hcl
          iam/
            terragrunt.hcl
          messaging/
            terragrunt.hcl
          cache/
            terragrunt.hcl
          monitoring/
            terragrunt.hcl
          cloudrun/
            terragrunt.hcl
          gitops/
            terragrunt.hcl
        staging/
          terragrunt.hcl
          region.hcl
          README.md
          network/
            terragrunt.hcl
          iam/
            terragrunt.hcl
          messaging/
            terragrunt.hcl
          cache/
            terragrunt.hcl
          monitoring/
            terragrunt.hcl
          cloudrun/
            terragrunt.hcl
          gitops/
            terragrunt.hcl
        prod/
          terragrunt.hcl
          region.hcl
          README.md
          network/
            terragrunt.hcl
          iam/
            terragrunt.hcl
          messaging/
            terragrunt.hcl
          cache/
            terragrunt.hcl
          monitoring/
            terragrunt.hcl
          cloudrun/
            terragrunt.hcl
          gitops/
            terragrunt.hcl
      modules/
        README.md
        network/
          README.md
          main.tf
          variables.tf
          outputs.tf
        iam/
          README.md
          main.tf
          variables.tf
          outputs.tf
        pubsub/
          README.md
          main.tf
          variables.tf
          outputs.tf
        redis/
          README.md
          main.tf
          variables.tf
          outputs.tf
        cloudsql/
          README.md
          main.tf
          variables.tf
          outputs.tf
        monitoring/
          README.md
          main.tf
          variables.tf
          outputs.tf
        cloudrun/
          README.md
          main.tf
          variables.tf
          outputs.tf
        gitops/
          README.md
          main.tf
          variables.tf
          outputs.tf
      INFRASTRUCTURE/
        (reserved for generated or runtime artifacts)
```

## Root-level Terragrunt configuration

### `live/terragrunt.hcl`
Root configuration that all environments inherit from. 
Responsibilities:
- set Terraform version requirement
- specify provider block defaults
- define common remote state backend strategy
- establish naming conventions
- set default region and project prefix
- configure any shared inputs

### `live/account.hcl`
Account-level or project-level defaults. 
Responsibilities:
- GCP project configuration
- organization and folder structure
- billing account reference
- service account naming conventions
- shared tags or labels

### `live/region.hcl`
Region and zone defaults. 
Responsibilities:
- default region (e.g., `us-central1`)
- default zones for multi-zone deployments
- secondary region if applicable
- disaster recovery region reference

## Environment-level structure

Each environment (dev, test, staging, prod) follows the same folder pattern.

### `live/{env}/terragrunt.hcl`
Environment-specific root configuration. 
Responsibilities:
- inherit from parent `terragrunt.hcl`
- set environment-specific project ID
- override region or zones if different
- set environment-specific labels and tags
- define environment-specific resource quotas
- configure state backend path for this environment

### `live/{env}/region.hcl`
Environment-specific region overrides. 
Responsibilities:
- allow a different region for this environment (e.g., STAGING in Europe, PROD in US)
- define zones specific to this environment

### `live/{env}/README.md`
Environment-specific documentation. 
Should include:
- description of the environment's purpose
- approval gates for deployment
- contact or ownership information
- special configuration or access requirements
- expected costs or quota limits
- known differences from other environments

### `live/{env}/{module}/terragrunt.hcl`
Component-specific Terragrunt configuration for this environment. Responsibilities:
- reference the correct Terraform module from `../modules/{module}`
- pass environment-specific inputs (e.g., smaller instance size for DEV)
- set component-level backend state path
- define dependencies on other components
- configure any module-specific outputs

Example component patterns:
- `network/`: VPC, subnets, firewall rules
- `iam/`: service accounts, IAM bindings, workload identity
- `messaging/`: Pub/Sub topics, subscriptions, dead-letter queues(DLQs)
- `cache/`: Redis / Memorystore, connection pools, TTL policies
- `monitoring/`: Cloud Logging, Cloud Monitoring, dashboards, alerts
- `cloudrun/`: Cloud Run services, traffic management, autoscaling
- `gitops/`: Argo CD or Flux configuration for this environment


## Terraform modules folder structure

### `modules/{module}/`
Each reusable Terraform module follows a standard pattern. 
Responsibilities:
- `main.tf`: resource definitions
- `variables.tf`: input variable definitions
- `outputs.tf`: output value definitions
- `README.md`: documentation for module usage

### Module responsibilities
Modules should be agnostic to environment. They accept input from Terragrunt and produce consistent outputs. For example:

- `modules/network/` defines a VPC and subnets but does not assume DEV vs. PROD sizing
- `modules/redis/` defines a Redis/Memorystore instance but accepts `environment_name`, `instance_size`, and `node_count` as inputs
- `modules/monitoring/` defines dashboards and alerts but accepts alert thresholds as inputs

## Environment-specific configuration patterns

### DEV environment
Purpose: development and feature iteration

Characteristics:
- smaller instance sizes
- minimal high-availability (single zone or zonal)
- relaxed resource limits
- automated cleanup or expiry policies
- developer-friendly IAM (broader local permissions)
- quick feedback loops

### TEST environment
Purpose: integration and regression validation

Characteristics:
- realistic but smaller resource sizing
- regional high-availability
- strict schema and contract validation
- comprehensive integration testing
- tighter IAM (mimics production permissions)
- approval workflow for database changes

### STAGING environment
Purpose: release-readiness gate

Characteristics:
- production-like resource sizing
- cross-regional high-availability or multi-region failover setup
- smoke tests and end-to-end validation
- realistic performance testing
- near-production IAM and security
- approval and change control gates

### PROD environment
Purpose: production deployment

Characteristics:
- maximum resource sizing and resilience
- multi-region or active-active high-availability
- strict access controls and audit trails
- manual approval required for changes
- comprehensive monitoring and alerting
- defined rollback procedures


## Configuration inheritance and override flow

### Inheritance chain
1. Root `live/terragrunt.hcl`
2. Environment-specific `live/{env}/terragrunt.hcl`
3. Component-specific `live/{env}/{module}/terragrunt.hcl`

Each level can inherit from and override values at the level above.

### Override patterns
A component in DEV might look like:

```text
live/dev/cache/terragrunt.hcl
  ├── inherits from live/dev/terragrunt.hcl
  ├── sets memory_size_gb (smaller for DEV)
  ├── sets node_count (1 for DEV)
  └── passes values to modules/redis/
```

The same module in PROD might look like:

```text
live/prod/cache/terragrunt.hcl
  ├── inherits from live/prod/terragrunt.hcl
  ├── sets memory_size_gb (larger for PROD)
  ├── sets node_count (3 or more for PROD)
  ├── enables backups and replication
  └── passes values to modules/redis/
```


## State management

### Remote state backend
Each component or environment should have a dedicated remote state backend:

- State files should be stored in GCS buckets
- Buckets should be versioned
- Bucket naming: `{project_id}-{environment}-tfstate`
- State locking should use GCS bucket conditions or Terraform backend locking

Example state paths:
- `gs://hotel-events-dev-tfstate/live/dev/network/terraform.tfstate`
- `gs://hotel-events-prod-tfstate/live/prod/network/terraform.tfstate`

### State separation
Each component (network, iam, messaging, cache, monitoring, cloudrun, gitops) can have its own Terraform state file or share one per environment. The choice depends on dependency and change velocity. Recommendations:

- **Separate state**: network, iam, messaging, cache (lower coupling)
- **Shared state**: monitoring, gitops (tightly integrated with other components)


## Deployment and promotion workflow

### Local development
```bash
cd PLATFORM/PROVIDERS/GCP/live/dev/network
terragrunt init
terragrunt plan
terragrunt apply
```

### CI/CD promotion
```
PR (plan all environments)
  ↓
Merge to main (auto-deploy to DEV)
  ↓
Promote to TEST (manual or automated gate)
  ↓
Promote to STAGING (requires approval)
  ↓
Promote to PROD (requires approval + change log)
```

## Documentation and discovery
Each folder should include a `README.md` documenting:
- Purpose
- Dependencies
- Inputs and expected values per environment
- Outputs and how they are used downstream
- Example deployments
- Troubleshooting or common issues

## Key principles

1. **DRY (Don't Repeat Yourself)**: Shared config in root `terragrunt.hcl`, environment overrides in respective folders.
2. **Immutability**: Shared modules are immutable; Terragrunt configs adapt them per environment.
3. **Traceability**: Each file has a clear responsibility; logs and state paths are predictable.
4. **Testability**: Modules and Terragrunt configs can be tested in DEV before promoting to higher environments.
5. **Governance**: Environment folders encode access and approval rules at the folder level.

## Next steps

1. Create the folder structure as described
2. Populate root `terragrunt.hcl` and environment-level configs
3. Define one or two modules (network, iam) as proof of concept
4. Set up CI/CD pipelines to validate and deploy using Terragrunt
5. Document environment-specific requirements and access patterns
6. Scale to remaining modules (messaging, cache, monitoring, cloudrun, gitops) once initial pattern is validated
