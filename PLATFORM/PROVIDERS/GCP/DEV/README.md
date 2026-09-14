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
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md",
    "APPS/APIgee/README.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md"
]
updated_by = "AI Context Specialist"
version = "1.1"
+++

> **Parent**: [`PLATFORM/PROVIDERS/GCP/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/README.md)  
> **Related**: [`TERRAFORM/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md) | [`TERRAFORM/terragrunt.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md) | [`APPS/APIgee/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/APIgee/README.md) | [`ARCHITECTURE/architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md)  
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
- Custom VPC (`apigee-vpc`) in `us-central1`
- Application compute subnet (`apigee-subnet`, `10.100.0.0/24`) with Private Google Access
- Regional Envoy proxy-only subnet (`apigee-proxy-only-subnet`, `10.100.1.0/24`, `REGIONAL_MANAGED_PROXY`)
- Private Service Access (PSA) reserved `/22` peering block for Apigee runtime
- Basic firewall rules with developer access

### API Gateway & Management (Apigee X Evaluation)
- Apigee Instance in `us-central1` attached to `/22` peering range
- Environment `dev` attached to Environment Group `dev-env-group`
- Private Service Connect (PSC) NEG connected to Regional External Application Load Balancer
- Dual frontends: HTTP (Port 80) for testing and HTTPS (Port 443 with self-signed certificate)
- Sample mock hotel events proxy (`/v1/healthz`, `/v1/events/inquiries`) with automated deployment script (`deploy-proxy.sh`) and smoke tester (`test-apigee.sh`)

### Identity and Access Management

> Planned inventory: 5 runtime service accounts for the initial DEV environment.

Each DEV service uses a dedicated service account:
- `hotel-events-dev-inquiry-sa`
- `hotel-events-dev-availability-sa`
- `hotel-events-dev-pricing-sa`
- `hotel-events-dev-booking-sa`
- `hotel-events-dev-operations-sa`

Initial least-privilege role plan:
- `hotel-events-dev-inquiry-sa`: `roles/logging.logWriter`, `roles/monitoring.metricWriter`, `roles/pubsub.publisher`
- `hotel-events-dev-availability-sa`: `roles/pubsub.publisher`, `roles/pubsub.subscriber`, `roles/logging.logWriter`, `roles/monitoring.metricWriter`
- `hotel-events-dev-pricing-sa`: `roles/pubsub.publisher`, `roles/pubsub.subscriber`, `roles/logging.logWriter`, `roles/monitoring.metricWriter`
- `hotel-events-dev-booking-sa`: `roles/pubsub.publisher`, `roles/pubsub.subscriber`, `roles/logging.logWriter`, `roles/monitoring.metricWriter`
- `hotel-events-dev-operations-sa`: `roles/pubsub.publisher`, `roles/logging.logWriter`, `roles/monitoring.metricWriter`, `roles/cloudtrace.agent`

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

> Status: Pending / Not started
>
> GitOps reconciliation, branch-driven promotions, and deployment automation are planned for a later phase and are not yet implemented in this environment.

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

> Status: Pending / Not started
>
> Automated CI/CD validation and deployment hooks for DEV are not yet implemented. This section describes the target workflow only.

- Changes to the infrastructure folder trigger CI validation
- `terragrunt run-all plan` validates all DEV components
- Merges to `main` automatically deploy to DEV
- Tests validate deployment success


## Access and authentication

### Service accounts

> Planned inventory: 5 runtime service accounts for the initial DEV environment.

Each DEV service uses a dedicated service account:
- `hotel-events-dev-inquiry-sa`
- `hotel-events-dev-availability-sa`
- `hotel-events-dev-pricing-sa`
- `hotel-events-dev-booking-sa`
- `hotel-events-dev-operations-sa`

Initial least-privilege role plan:
- `hotel-events-dev-inquiry-sa`: `roles/logging.logWriter`, `roles/monitoring.metricWriter`, `roles/pubsub.publisher`
- `hotel-events-dev-availability-sa`: `roles/pubsub.publisher`, `roles/pubsub.subscriber`, `roles/logging.logWriter`, `roles/monitoring.metricWriter`
- `hotel-events-dev-pricing-sa`: `roles/pubsub.publisher`, `roles/pubsub.subscriber`, `roles/logging.logWriter`, `roles/monitoring.metricWriter`
- `hotel-events-dev-booking-sa`: `roles/pubsub.publisher`, `roles/pubsub.subscriber`, `roles/logging.logWriter`, `roles/monitoring.metricWriter`
- `hotel-events-dev-operations-sa`: `roles/pubsub.publisher`, `roles/logging.logWriter`, `roles/monitoring.metricWriter`, `roles/cloudtrace.agent`

### Local developer access
Developers use their Google Cloud identity or a shared DEV service account with:
- `roles/compute.admin` for Cloud Run management
- `roles/pubsub.admin` for Pub/Sub management
- `roles/storage.admin` for GCS access
- `roles/logging.viewer` for log access
- `roles/monitoring.viewer` for metrics access


### Secret management
DEV secrets are stored in GCP Secret Manager using placeholder values for the initial project bootstrap:
- `hotel-events-dev-salesforce-api-key`
- `hotel-events-dev-salesforce-client-secret`
- `hotel-events-dev-mulesoft-client-id`
- `hotel-events-dev-mulesoft-client-secret`
- `hotel-events-dev-redis-password`
- `hotel-events-dev-database-password`

This is the first-pass inventory. The actual secrets should be rotated and replaced once the project is live and the operational owners are confirmed.

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

### Terraform service account declaration standard

The DEV Terraform bootstrap will declare service account IAM bindings using the following pattern:

```hcl
member = "serviceAccount:service-${var.inquiry_service_account_id}@${var.compute_project_id}.iam.gserviceaccount.com"
```

This keeps the runtime service account IDs configurable via `dev.tfvars`, while still producing the correct Google-managed service account email string for each project-scoped IAM binding.

The same pattern is used for all explicit role assignments for:
- `hotel-events-dev-inquiry-sa`
- `hotel-events-dev-availability-sa`
- `hotel-events-dev-pricing-sa`
- `hotel-events-dev-booking-sa`
- `hotel-events-dev-operations-sa`

> Note: The repo intentionally preserves the full change history in `changelog.md`. New notes are appended without deleting earlier entries, and the current standard is documented here as the canonical pattern for all project-scoped service account bindings.

