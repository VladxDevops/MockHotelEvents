+++
title = "PLATFORM / PROVIDERS / GCP - AI Agent Guide"
domain = "infrastructure"
topics = ["gcp", "infrastructure", "terraform", "terragrunt", "agents"]
difficulty = "advanced"
progressive_tier = "Tier 3"
parent = "PLATFORM/PROVIDERS/Agents.md"
children = []
related = [
    "PLATFORM/PROVIDERS/Agents.md",
    "PLATFORM/PROVIDERS/GCP/README.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`PLATFORM/PROVIDERS/Agents.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/Agents.md)  
> **Related**: [`PLATFORM/PROVIDERS/GCP/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/README.md) | [`TERRAFORM/terragrunt.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md) | [`TERRAFORM/folder-structure.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Routes AI agent requests related to GCP infrastructure, Terraform modules, and Terragrunt multi-environment configuration.
- Questions Answered: What GCP resources are used, how is Terraform organized, and how does Terragrunt manage environments?
- When to Retrieve: Working on GCP infrastructure, Terraform modules, Terragrunt configuration, or environment-specific deployments.
- When NOT to Retrieve: Working on application code, Salesforce, MuleSoft, or core business logic.
-->


# PLATFORM / PROVIDERS / GCP - AI Agent Guide

This guide helps AI agents navigate and understand the GCP infrastructure implementation for the Hotel Events project.


## Folder overview

The GCP provider implementation contains:

| Folder | Purpose | Status |
| :--- | :--- | :--- |
| `TERRAFORM/` | Terraform documentation, Terragrunt guides, modules library | Active |
| `live/` | Environment-specific Terragrunt configurations | To be created |
| `modules/` | Reusable Terraform module library | To be created |
| `DEV/` | Development environment context | Active |
| `OBSERVABILITY/` | Monitoring and logging configuration | Reserved |
| `SECURITY/` | Security policies and compliance | Reserved |


## Key documentation entry points

### Infrastructure planning
- `README.md` — GCP overview and index
- `TERRAFORM/README.md` — Terraform and Terragrunt overview
- `TERRAFORM/terragrunt.md` — Complete Terragrunt guide
- `TERRAFORM/folder-structure.md` — Folder layout and responsibilities
- `TERRAFORM/cloud-infrastructure-checklist.md` — Full resource checklist
- `TERRAFORM/dev-environment-starter-architecture.md` — DEV environment design


### Environment-specific context
- `DEV/README.md` — Development environment characteristics and governance


### Related architecture
- `DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md` (parent project) — Include GCP context


## Terragrunt structure

### Organization principle
Terragrunt separates **what** is deployed (Terraform modules) from **how** it is deployed (environment configuration):

- **Modules** (`modules/`): Define cloud resources in reusable, environment-agnostic Terraform
- **Live** (`live/`): Define environment-specific configuration and orchestration using Terragrunt

### Environment folders

```
live/
  ├── terragrunt.hcl           (root config, shared defaults)
  ├── account.hcl              (GCP project conventions)
  ├── region.hcl               (region/zone defaults)
  ├── dev/                      (DEV environment)
  │   ├── terragrunt.hcl       (DEV overrides)
  │   ├── region.hcl
  │   ├── network/terraform.tf → modules/network
  │   ├── iam/
  │   ├── messaging/
  │   ├── cache/
  │   ├── monitoring/
  │   └── cloudrun/
  ├── test/                     (TEST environment)
  ├── staging/                  (STAGING environment)
  └── prod/                     (PROD environment)
```

Each component folder in `live/{env}/` contains a `terragrunt.hcl` file that:
- References the corresponding module from `modules/{component}`
- Passes environment-specific inputs
- Defines component dependencies


### Module structure

```
modules/
  ├── network/
  │   ├── README.md
  │   ├── main.tf              (resource definitions)
  │   ├── variables.tf         (input variables)
  │   └── outputs.tf           (output values)
  ├── iam/
  ├── pubsub/
  ├── redis/
  ├── cloudsql/
  ├── monitoring/
  ├── cloudrun/
  └── gitops/
```


## Agent task patterns

### Creating a new Terraform module
1. Create `modules/{component}/` folder
2. Add `main.tf`, `variables.tf`, `outputs.tf`
3. Document in `README.md`
4. Make environment-agnostic (all environment differences go in Terragrunt)


### Deploying a component to an environment
1. Create `live/{env}/{component}/terragrunt.hcl`
2. Reference the module from `../../../modules/{component}`
3. Pass environment-specific inputs
4. Define dependencies on other components if needed


### Creating a new environment (TEST, STAGING, PROD)
1. Copy `live/dev/` structure to `live/{env}/`
2. Update `terragrunt.hcl` with:
   - New project ID
   - Region (if different)
   - Resource sizing
   - Access controls
   - Backup policies
3. Create `README.md` with environment characteristics
4. Validate with `terragrunt plan` before applying


### Modifying configuration across all environments
1. Update the module in `modules/{component}/`
2. Update component configs in `live/{env}/{component}/`
3. Test in DEV first with `terragrunt plan`
4. Promote through TEST, STAGING, PROD following approval gates


## Core components

### Network
- VPC and subnets per environment
- Firewall rules and ingress policies
- Private service access for managed services
- Load balancing if required


### IAM
- Service accounts per application or component
- Role bindings with least-privilege
- Workload Identity for service-to-service auth
- Cross-environment access restrictions


### Messaging (Pub/Sub)
- Topics for key event types (lead, inquiry, availability, quote, booking, handoff)
- Subscriptions for each consumer
- Dead-letter queue pattern
- Retry and backoff configuration


### Cache (Redis)
- Memorystore Redis instance
- Single-node for DEV, multi-node for PROD
- TTL and eviction policies
- Connection pool configuration


### Database (Cloud SQL)
- Lightweight operational data store
- Environment-specific sizing
- Backup and recovery configuration
- Migration and rollback strategy


### Monitoring
- Cloud Logging sinks and log aggregation
- Cloud Monitoring dashboards and alerts
- Cloud Trace configuration
- OpenTelemetry collector setup


### Cloud Run
- API and event processing services
- Autoscaling and cold-start optimization
- Environment variables and secrets
- Service-to-service communication


### GitOps
- Argo CD or Flux for infrastructure sync
- Git-driven environment reconciliation
- Drift detection and correction
- Rollback and promotion workflows


## DEV environment specifics

The DEV environment is configured for rapid iteration:

| Aspect | DEV Configuration |
| :--- | :--- |
| Region | `us-central1` |
| Availability | Zonal |
| Resource sizing | Small, cost-optimized |
| Backup | Optional |
| Access | Developer-friendly |
| Approval gates | Minimal |
| Auto-cleanup | Enabled |

See `DEV/README.md` for full DEV environment context.


## Deployment workflow

### Local development
```bash
cd PLATFORM/PROVIDERS/GCP/live/dev/{component}
terragrunt init
terragrunt plan     # Review changes
terragrunt apply    # Deploy to DEV
```

### Across environments
```bash
# DEV: typically auto-deploy on merge to main
cd live/dev
terragrunt run-all plan
terragrunt run-all apply

# TEST: manual or gated approval
cd live/test
terragrunt run-all plan
# ... review and approve ...
terragrunt run-all apply

# STAGING: release-readiness gates
cd live/staging
terragrunt run-all plan
# ... review, test, approve ...
terragrunt run-all apply

# PROD: strict approval and audit
cd live/prod
terragrunt run-all plan
# ... security review, final approval, audit log ...
terragrunt run-all apply
```


## Security and IAM

### Least privilege
- Each service has a dedicated service account
- Roles are scoped narrowly to required resources
- Cross-environment access is restricted

### Secret management
- All credentials stored in GCP Secret Manager
- Never committed to Git
- Injected at runtime into services

### Audit trails
- All infrastructure changes logged
- Terraform state tracked in version control
- GitOps sync events monitored


## Observability

### Logging
- All services emit structured logs to Cloud Logging
- Correlation IDs propagated across services
- Environment-specific log retention policies

### Metrics
- Latency and throughput per component
- Error rates and retry attempts
- Resource utilization and cost tracking


### Tracing
- OpenTelemetry instrumentation in all services
- Distributed trace context propagated
- Trace data stored in Cloud Trace


## Next steps for agents

1. **Understand Terragrunt**: Read `TERRAFORM/terragrunt.md` for concept and commands
2. **Plan structure**: Review `TERRAFORM/folder-structure.md` for folder layout
3. **Design DEV**: Study `DEV/README.md` for first environment implementation
4. **Create modules**: Implement core Terraform modules (network, iam, messaging, cache)
5. **Deploy DEV**: Use Terragrunt to deploy DEV environment
6. **Replicate environments**: Create TEST, STAGING, PROD following the same patterns
7. **Integrate CI/CD**: Connect Terragrunt commands to CI/CD pipelines for automated promotion

