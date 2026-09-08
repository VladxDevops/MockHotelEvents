+++
title = "PLATFORM / PROVIDERS - AI Agent Guide"
domain = "infrastructure"
topics = ["platform", "providers", "infrastructure", "agents"]
difficulty = "advanced"
progressive_tier = "Tier 3"
parent = "Agents.md"
children = []
related = [
    "Agents.md",
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "PLATFORM/PROVIDERS/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`Agents.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/Agents.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/README.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Routes AI agent requests related to multi-cloud provider infrastructure, Terraform, and Terragrunt configuration.
- Questions Answered: Which cloud provider implementations exist, and where is infrastructure-as-code stored?
- When to Retrieve: Working on infrastructure implementations, cloud provider selection, or multi-environment Terraform/Terragrunt patterns.
- When NOT to Retrieve: Working on application code or runtime service implementations.
-->

# PLATFORM / PROVIDERS - AI Agent Guide

This guide helps AI agents navigate and understand the PLATFORM/PROVIDERS folder structure, which coordinates cloud provider implementations for the Hotel Events project.

## Folder overview

The PLATFORM/PROVIDERS folder organizes infrastructure-as-code and cloud provider configuration:

| Folder | Status | Use |
| :--- | :--- | :--- |
| `GCP/` | Active | Google Cloud Platform infrastructure, Terraform modules, Terragrunt configuration |
| `AWS/` | Reserved | Amazon Web Services provider (placeholder for future implementation) |
| `AZURE/` | Reserved | Microsoft Azure provider (placeholder for future implementation) |
| `ONPREM/` | Reserved | On-premises infrastructure (placeholder for future implementation) |

## GCP implementations

The GCP provider folder contains the primary infrastructure implementation for Hotel Events:

### Key paths
- `GCP/TERRAFORM/` — Terraform modules and Terragrunt documentation
- `GCP/TERRAFORM/terragrunt.md` — Terragrunt installation and usage guide
- `GCP/TERRAFORM/folder-structure.md` — Folder organization and component responsibilities
- `GCP/live/` — Environment-specific configurations (to be created: dev, test, staging, prod)
- `GCP/modules/` — Reusable Terraform module library (to be created)
- `GCP/DEV/` — Development environment context and governance
- `GCP/OBSERVABILITY/` — Monitoring and logging setup (reserved)
- `GCP/SECURITY/` — Security policies and compliance (reserved)

### Agent task patterns

**For infrastructure planning or design:**
1. Read `PLATFORM/PROVIDERS/README.md` for high-level structure
2. Read `PLATFORM/PROVIDERS/GCP/README.md` for GCP-specific overview
3. Reference `PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md` for Terragrunt patterns
4. Consult `PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md` for folder responsibilities

**For environment-specific work:**
1. Start with the environment documentation (e.g., `GCP/DEV/README.md`)
2. Review environment characteristics and constraints
3. Reference the Terragrunt folder pattern from `folder-structure.md`
4. Align with the GCP architecture checklist from `TERRAFORM/cloud-infrastructure-checklist.md`

**For network, IAM, or observability work:**
1. Identify the component name (network, iam, pubsub, redis, monitoring, cloudrun, gitops)
2. Check if a module exists in `GCP/modules/{component}/`
3. Reference the Terraform module documentation within that folder
4. Consult `TERRAFORM/dev-environment-starter-architecture.md` for design context

## Related documentation

### Core architecture
- `DOCUMENTATION/INTERNAL/spects.md` — project specifications and system scope
- `DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md` — full architecture reference including Terragrunt context
- `DOCUMENTATION/INTERNAL/security.md` — security and compliance patterns

### Terraform and Terragrunt
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md` — Terraform overview and index
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md` — Terragrunt guide with installation and CI/CD patterns
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md` — Exact folder layout and configuration inheritance patterns
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md` — infrastructure components and checklist
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md` — DEV environment starter architecture

### Environment context
- `PLATFORM/PROVIDERS/GCP/DEV/README.md` — DEV environment characteristics, governance, and deployment guidance

## Terragrunt and multi-environment context

### Why Terragrunt matters
Terragrunt wraps Terraform to manage consistent configurations across DEV, TEST, STAGING, and PROD environments without code duplication. It enables:

- Shared root configuration with environment-specific overrides
- Consistent remote state management
- Cleaner CI/CD and promotion workflows
- Clear separation of concerns between environment and components

### Folder structure pattern
The Terragrunt structure mirrors this layout:

```
live/
  terragrunt.hcl          (root config, inherited by all)
  account.hcl             (GCP project conventions)
  region.hcl              (region and zone defaults)
  dev/                    (DEV environment folder)
    terragrunt.hcl        (DEV-specific overrides)
    region.hcl            (DEV region override if different)
    network/
      terragrunt.hcl      (network component config)
    iam/
      terragrunt.hcl      (IAM component config)
    ...
  test/                   (TEST environment folder)
  staging/                (STAGING environment folder)
  prod/                   (PROD environment folder)

modules/                  (reusable Terraform modules)
  network/
  iam/
  pubsub/
  redis/
  monitoring/
  cloudrun/
  gitops/
```

### Configuration inheritance
Each level can inherit and override values from above:
- Root `terragrunt.hcl` defines project, region, provider defaults
- `{env}/terragrunt.hcl` overrides with environment-specific values
- `{env}/{component}/terragrunt.hcl` specifies which module to deploy and with what inputs

## Agent workflows

### Planning new infrastructure
1. Start with `DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md` to understand what needs to be built
2. Check `PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md` for scope
3. Review `PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md` for DEV environment design
4. Use `PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md` to determine where to place Terragrunt and Terraform code

### Extending existing infrastructure
1. Review the existing component in `GCP/modules/{component}/`
2. Check the corresponding Terragrunt deployment in `GCP/live/dev/{component}/`
3. Modify the module or Terragrunt config as needed
4. Test changes in DEV first
5. Promote to higher environments following the folder and promotion pattern

### Creating a new environment (TEST, STAGING, PROD)
1. Copy the DEV folder structure to the new environment folder
2. Update `{env}/terragrunt.hcl` with environment-specific settings:
   - Project ID
   - Region (if different)
   - Resource sizing
   - Access controls
   - Backup and retention policies
3. Create `{env}/README.md` documenting environment characteristics
4. Follow the promotion workflow with CI/CD validation

### Troubleshooting infrastructure issues
1. Check the environment documentation: `GCP/{env}/README.md`
2. Review the Terragrunt folder structure: `PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md`
3. Consult the specific module documentation: `GCP/modules/{component}/README.md`
4. Reference the architecture documentation for design decisions
5. Check logs and observability setup: `GCP/OBSERVABILITY/`

## Best practices

### Documentation first
Always document infrastructure decisions in README files co-located with the code:
- `GCP/modules/{component}/README.md` for module usage
- `GCP/live/{env}/README.md` for environment characteristics
- `TERRAFORM/` folder for architecture and decision documentation

### Terraform module conventions
- One responsibility per module (network, iam, messaging, cache, etc.)
- Inputs for configuration, outputs for downstream consumption
- No hardcoded environment values; use inputs for flexibility

### Terragrunt conventions
- Inherit from root `terragrunt.hcl` to minimize repetition
- Override only what differs per environment
- Use `dependency` blocks to express component ordering
- Leverage `run_all` for coordinated multi-component deployment

### Security and compliance
- Least-privilege IAM by default
- Secret management via GCP Secret Manager (not in Git)
- Encryption for data in transit and at rest
- Audit trails for infrastructure changes
- Regular security reviews per environment

## Next steps for agents

1. **Exploring**: Read `PLATFORM/PROVIDERS/GCP/README.md` for an overview
2. **Learning**: Study `PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md` for Terragrunt concepts
3. **Planning**: Review `PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md` for implementation structure
4. **Implementing**: Start with DEV environment following the folder pattern
5. **Scaling**: Replicate patterns to TEST, STAGING, and PROD when ready

