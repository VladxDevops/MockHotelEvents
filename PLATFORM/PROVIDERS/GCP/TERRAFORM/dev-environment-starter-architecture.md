+++
title = "Starter Terraform / GCP Dev Architecture Plan"
domain = "infrastructure"
topics = ["terraform", "gcp", "infrastructure", "gitops"]
difficulty = "advanced"
progressive_tier = "Tier 3"
parent = "PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md"
children = []
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
# Starter Terraform / GCP Dev Architecture Plan

## Purpose
This is a starter plan for a DEV-only Google Cloud implementation of the hotel wedding inquiry architecture. The goal is to keep the design realistic, simple enough to build, and faithful to the repo’s event-driven integration story.

## Target architecture
The DEV environment should support this core flow:

1. Salesforce creates or updates a lead or event request.
2. Mulesoft orchestrates the wedding inquiry and normalizes the payload.
3. A backend service validates venue availability and event requirements.
4. A quote service calculates pricing.
5. Events are emitted to Pub/Sub or Kafka.
6. Consumers process updates, store or cache state, and notify downstream systems.
7. Telemetry collects trace, log, and metric data across the flow.

## Recommended GCP services

### Core platform
- VPC / custom network
- Subnets for app, data, and internal services
- Cloud Router / NAT if outbound internet access is required
- Firewall rules and private networking for service isolation

### Compute and app runtime
- Cloud Run for lightweight APIs and event processors
- Optional GKE if the team wants a container orchestration model later
- Artifact Registry for container images
- Cloud Build or GitHub Actions for CI/CD

### Messaging
- Pub/Sub topics for each stage of the event lifecycle
- Topic examples:
  - `wedding.lead.created`
  - `wedding.inquiry.received`
  - `wedding.availability.requested`
  - `wedding.quote.generated`
  - `wedding.booking.confirmed`
  - `wedding.operations.handoff`
- Subscriptions or consumer workers for event processing
- Dead-letter topic pattern for poison messages and retries

### Data and cache
- Memorystore for Redis for cached availability and quote snapshots
- Cloud SQL or Spanner for an operational booking record and event state store
- Keep Redis as a cache layer, not the system of record

### Security and identity
- One service account per app or worker
- Workload Identity Federation where applicable
- Secret Manager for credentials, API tokens, and integration secrets
- Least-privilege IAM roles

### Observability
- Cloud Logging
- Cloud Monitoring
- Cloud Trace
- OpenTelemetry instrumentation in all services
- Log and metric dashboards for event throughput, errors, and latency

### GitOps and delivery

> Status: Pending / Not started
>
> GitOps sync, Terragrunt live folders, and automated promotion logic are planned for a future phase and are not yet implemented.

- Argo CD or Flux for sync and deployment promotion
- Git repository as source of truth
- Separate config values per environment
- DEV-first delivery, then expansion to TEST/STAGING/PROD

## Recommended DEV resource layout

### Networking
- One shared VPC
- App subnet for Cloud Run and internal services
- Data subnet for Redis and database services
- Private service access for managed services where needed
- Firewall rules that allow only required egress and ingress paths

### Messaging layer
- Pub/Sub topic set for inquiry lifecycle
- One subscription per major consumer
- DLQ for each major queue
- Retry policy for transient failures

### App services
- Inquiry intake API
- Availability validation service
- Quote generation service
- Booking confirmation service
- Operational handoff service

### Data layer
- Memorystore Redis instance with short TTL values
- Cloud SQL database for operational records or a lightweight sample datastore
- Store only the essential booking and event state required for the mock project

### Observability layer
- OpenTelemetry collector or SDK instrumentation in each service
- Trace correlation across Salesforce, Mulesoft, Pub/Sub, and backend services
- Alerts for queue lag, API failures, and booking flow errors

## Terraform module structure
A practical repo structure could look like this:

```text
terraform/
  environments/
    dev/
      main.tf
      variables.tf
      terraform.tfvars
  modules/
    network/
    pubsub/
    redis/
    database/
    monitoring/
    iam/
    service-accounts/
    gitops/
```

## Suggested resources to provision in DEV
- VPC and subnets
- IAM service accounts
- Secret Manager entries
- Pub/Sub topics and subscriptions
- Memorystore Redis instance
- Cloud SQL or Spanner instance
- Cloud Run services or GKE namespace
- Cloud Logging sinks
- Cloud Monitoring alerts
- Artifact Registry repository
- GitOps controller installation (Argo CD or Flux)

## Terraform design principles
- Keep environment-specific values in `terraform.tfvars` or a `dev.auto.tfvars` pattern.
- Use remote state storage with locking.
- Separate modules by responsibility.
- Use variables for environment names, project IDs, and service config.
- Add tagging and labels to all resources for ownership and cost tracking.
- Keep security baseline rules explicit and documented.

## Secure-by-default implementation checklist
- [ ] Private networking enabled where practical
- [ ] Service accounts with least privilege
- [ ] Secret Manager used for all API credentials
- [ ] TLS enforced for service-to-service traffic
- [ ] no broad public access to admin endpoints
- [ ] Terraform remote state configured securely
- [ ] IAM access reviewed before moving to more advanced environments

## Dev-first rollout plan
1. Provision the VPC and IAM foundations.
2. Create Pub/Sub topics and subscriptions.
3. Deploy Redis and a minimal operational database.
4. Deploy the inquiry and quote services.
5. Enable OpenTelemetry and dashboards.
6. Test the full flow:
   - lead created
   - inquiry received
   - quote generated
   - booking confirmed
7. Add GitOps sync and environment drift checks.
8. Expand to TEST/STAGING/PROD only after the DEV flow is stable.

## Final recommendation
For this repo, the best DEV starter architecture is:
- VPC + networking
- Pub/Sub event backbone
- Cloud Run services for app logic
- Memorystore Redis for cache
- Cloud SQL or Spanner for operational records
- OpenTelemetry + Cloud Monitoring for full traceability
- Terraform modules for repeatable environment provisioning
- GitOps with Argo CD or Flux for environment delivery

This is a credible mock architecture that is simple enough to learn from and realistic enough for a demo or interview conversation.
