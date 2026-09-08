+++
title = "PLATFORM / PROVIDERS / GCP / DEV - Development Environment Guide"
domain = "infrastructure"
topics = ["dev", "environment", "gcp", "terraform", "terragrunt"]
difficulty = "advanced"
progressive_tier = "Tier 3"
parent = "PLATFORM/PROVIDERS/GCP/README.md"
children = []
related = [
    "PLATFORM/PROVIDERS/GCP/README.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`PLATFORM/PROVIDERS/GCP/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/README.md)  
> **Related**: [`TERRAFORM/terragrunt.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md) | [`TERRAFORM/dev-environment-starter-architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md) | [`ARCHITECTURE/architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md)  
> **Progressive Tier**: Tier 3

# DEV Environment Guide

This document provides context and guidance for the DEV environment, which is the primary target for the initial Hotel Events infrastructure implementation.

## Purpose

The DEV environment is the development-friendly, low-friction deployment target for the Hotel Events platform. It is designed for:

- rapid iteration on infrastructure and application code
- testing new features or integration patterns
- validating GCP resource configurations
- experimenting with Terraform and Terragrunt patterns
- onboarding new team members to the cloud infrastructure

The DEV environment is not production-grade. It prioritizes developer experience and iteration speed over high availability and cost optimization.

## Environment characteristics

| Aspect | DEV Setting |
| :--- | :--- |
| Region | `us-central1` |
| Availability | Zonal (single zone) |
| Resource sizing | Small (cost-optimized) |
| High Availability | Not required |
| Backup strategy | Manual or optional |
| Approval gates | Minimal |
| Access controls | Developer-friendly |
| Retention policies | Short (auto-cleanup recommended) |
| Cost target | Minimal and experimental |

## Infrastructure components

The DEV environment includes:

### Network
- Single VPC in `us-central1`
- Application and data subnets
- Basic firewall rules with developer access
- Private service access for managed services

### Identity and Access Management
- Service accounts for each application component
- Developer service accounts with broad local permissions
- Local IAM bindings (not organizational policies)
- Minimal cross-environment access restrictions

### Messaging
- Pub/Sub topics for core event types
  - `wedding.lead.created`
  - `wedding.inquiry.received`
  - `wedding.availability.requested`
  - `wedding.quote.generated`
  - `wedding.booking.confirmed`
- Subscriptions for development testing
- Optional dead-letter queues for failed messages

### Cache and data storage
- Redis/Memorystore instance (small, single-node)
- Cloud SQL or lightweight database for operational records
- Minimal backup configuration

### Application services
- Cloud Run services for:
  - inquiry intake
  - availability validation
  - quote generation
  - booking confirmation
  - operations handoff
- Small instance counts (1 replica minimum)
- Relaxed cold-start and timeout tolerances

### Observability
- Cloud Logging with basic retention
- Cloud Monitoring with minimal alerts
- Cloud Trace for development debugging
- OpenTelemetry instrumentation in all services
- Developer-friendly dashboards

### GitOps
- Argo CD or Flux for DEV namespace/project
- Git-driven deployment from main or development branch
- Automatic drift reconciliation
- Quick rollback capability

## Deployment workflow

### Local development
```bash
# Setup
gcloud config set project hotel-events-dev
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

# Navigate to component
cd PLATFORM/PROVIDERS/GCP/live/dev/{component}

# Plan and apply
terragrunt init
terragrunt plan
terragrunt apply
```

### CI/CD deployment
- Changes to the infrastructure folder trigger CI validation
- `terragrunt run-all plan` validates all DEV components
- Merges to `main` automatically deploy to DEV
- Tests validate deployment success

## Access and authentication

### Service accounts
Each DEV service uses a dedicated service account:
- `hotel-events-dev-inquiry`
- `hotel-events-dev-availability`
- `hotel-events-dev-pricing`
- `hotel-events-dev-booking`

### Local developer access
Developers use their Google Cloud identity or a shared DEV service account with:
- `roles/compute.admin` for Cloud Run management
- `roles/pubsub.admin` for Pub/Sub management
- `roles/storage.admin` for GCS access
- `roles/logging.viewer` for log access
- `roles/monitoring.viewer` for metrics access

### Secret management
DEV secrets are stored in GCP Secret Manager:
- `hotel-events-dev-salesforce-api-key`
- `hotel-events-dev-mulesoft-credentials`
- `hotel-events-dev-database-password`
- Other integration credentials

## Cost management

DEV environment costs should be minimized through:

- small instance sizes and auto-scaling to zero
- single-zone deployment (no high availability)
- short log retention (30 days)
- automatic resource cleanup or expiry policies
- shared services where practical
- scheduled scaling down during off-hours (optional)

Estimated monthly cost: $50-200 (highly variable based on usage and services)

## Monitoring and alerting

DEV monitoring is developer-focused:

- logs are verbose and retained for 30 days
- key metrics are tracked (request latency, error rates, queue lag)
- alerts are minimal to avoid false positives
- dashboards show real-time component health
- traces are captured for debugging

## Troubleshooting and reset

### Clear all resources
```bash
cd PLATFORM/PROVIDERS/GCP/live/dev
terragrunt run-all destroy
```

### View logs
```bash
gcloud logging read "resource.labels.project_id=hotel-events-dev" \
  --limit 50 --format json
```

### Check deployments
```bash
gcloud run services list --project hotel-events-dev
gcloud pubsub topics list --project hotel-events-dev
```

### Reset database or cache
```bash
gcloud sql instances delete hotel-events-dev-db --project hotel-events-dev
gcloud redis instances delete hotel-events-dev-cache --project hotel-events-dev
```

## Next steps

1. Complete the folder structure under `live/dev/` as defined in `TERRAFORM/folder-structure.md`
2. Implement core modules (network, iam) as proof of concept
3. Validate Terragrunt workflow with local `terragrunt plan` and `terragrunt apply`
4. Set up CI/CD pipelines to deploy DEV automatically
5. Create TEST environment following the same pattern
6. Promote validated patterns to STAGING and PROD

