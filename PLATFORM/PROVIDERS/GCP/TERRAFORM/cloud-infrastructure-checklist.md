+++
title = "Cloud Infrastructure Checklist for the Current Project"
domain = "infrastructure"
topics = ["terraform", "gcp", "infrastructure", "gitops"]
difficulty = "advanced"
progressive_tier = "Tier 3"
parent = "DOCUMENTATION/INTERNAL/security.md"
children = []
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "APPS/REDIS/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/README.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Documents Terraform and Google Cloud infrastructure needed to run the mock Hotel Events platform.
- Questions Answered: What GCP and Terraform resources are needed, and how should environments be provisioned?
- When to Retrieve: Working on infrastructure context for the Hotel Events wedding inquiry platform.
- When NOT to Retrieve: Working on unrelated generated assets, dependency lockfiles, or implementation code that does not need documentation context.
-->
# Cloud Infrastructure Checklist for the Current Project

This checklist summarizes the cloud infrastructure likely needed for the current mock hotel events project based on the architecture, messaging, observability, and integration patterns already documented.

## Scope
This is a planning checklist for a realistic but mock GCP-based implementation of the current repo. It is not a production deployment specification.

## Core infrastructure components

### 1. Project and environment structure
- [ ] One GCP project or separate per environment strategy
- [ ] Dev environment
- [ ] Test environment
- [ ] Prod-like environment for demos or final architecture review
- [ ] Environment-specific variables and configuration
- [ ] Separate IAM roles per environment

### 2. Networking
- [ ] VPC or network design
- [ ] Subnets for application and data services
- [ ] Private service access where needed
- [ ] Firewall and ingress rules
- [ ] Security group or firewall policy equivalent
- [ ] NAT or egress control if required

### 3. Messaging and eventing
- [ ] Pub/Sub topic for inquiry events
- [ ] Pub/Sub topic for availability checks
- [ ] Pub/Sub topic for quote generation
- [ ] Pub/Sub topic for booking confirmation
- [ ] Pub/Sub topic for operational handoff
- [ ] Kafka cluster or managed streaming layer for higher-throughput event processing
- [ ] Consumer groups and subscriptions for event processing
- [ ] Dead-letter topic or DLQ pattern
- [ ] Retry and backoff strategy

### 4. Integration and app services
- [ ] Mulesoft runtime or equivalent integration layer
- [ ] API gateway or ingress pattern for integration requests
- [ ] Application service for inquiry intake or validation
- [ ] Availability validation service
- [ ] Quote/pricing service
- [ ] Booking confirmation service
- [ ] Operations handoff service
- [ ] Identity and authentication for each service-to-service connection

### 5. Data and cache
- [ ] Redis or Memorystore instance
- [ ] Cache for availability lookups
- [ ] Cache for pricing summaries or quote snapshots
- [ ] TTL and invalidation rules
- [ ] Source-of-truth data store for booking and operational records
- [ ] Data retention strategy for mock event logs and payloads

### 6. Observability
- [ ] OpenTelemetry instrumentation for all services
- [ ] Trace propagation across Salesforce, Mulesoft, messaging, and backend services
- [ ] Logs for request lifecycle and failures
- [ ] Metrics for latency, throughput, retries, and rate of errors
- [ ] Alerting rules for failed booking flow, queue lag, or service outages
- [ ] Dashboards for flow health and operational visibility
- [ ] Log retention and access controls

### 7. Security and identity
- [ ] Service accounts per component
- [ ] Least privilege IAM roles
- [ ] Secret management strategy
- [ ] TLS enforced for all service communication
- [ ] Network restriction rules for internal services
- [ ] Access controls for sales and operational tools
- [ ] Audit trail for booking and pricing changes
- [ ] Secure Terraform state and remote backend configuration

### 8. Terraform and IaC
- [ ] Terraform project structure
- [ ] Modules for networking
- [ ] Modules for messaging resources
- [ ] Modules for Redis and data services
- [ ] Modules for monitoring and logging
- [ ] Variables for environment configuration
- [ ] State backend config
- [ ] Locking and version control process
- [ ] Drift management and documentation

### 9. Deployment and release

> Status: Pending / Not started
>
> CI/CD pipeline setup, validation automation, and deployment promotion flows are planned for a later implementation phase and are not yet active in this repository.

- [ ] CI/CD pipeline for infrastructure changes
- [ ] Validation pipeline for Terraform plans
- [ ] Deployment flow for app and integration components
- [ ] Rollback strategy for failed deployments
- [ ] Release gates or approvals for production-like environments

### 10. Non-functional requirements
- [ ] Response time targets for inquiry processing
- [ ] Retry policies and timeouts
- [ ] Error budget assumptions
- [ ] Scalability expectations for peak event volume
- [ ] Recovery strategy for service outages
- [ ] Backlog and dead-letter monitoring

## Suggested minimal implementation footprint
If you wanted the smallest realistic mock environment, it would likely include:
- [ ] one VPC/network
- [ ] one Redis instance
- [ ] one Pub/Sub topic set for inquiry lifecycle
- [ ] one Kafka or equivalent stream processing layer
- [ ] one Mulesoft integration runtime
- [ ] one or more application services for validation and quote processing
- [ ] IAM and networking guardrails
- [ ] OpenTelemetry + monitoring stack
- [ ] Terraform modules for all infrastructure resources

## Recommended priority order
1. Security and IAM
2. Messaging and event flow
3. Platform networking
4. Redis and data/cache layer
5. Observability and tracing
6. Mulesoft and app services
7. Terraform and deployment automation

## Environment strategy
The project will follow a four-environment delivery model:
- Dev
- Test
- Staging
- Prod

For the current phase, we are focusing on the DEV environment first. The remaining environments will be planned in a way that keeps the same architecture and deployment model, but with stricter access controls and promotion gates as we move toward production-like delivery.

### Environment responsibilities
- Dev: active development, feature testing, and architecture iteration
- Test: validation of integration and regression behavior
- Staging: release-readiness checks, smoke tests, and near-production validation
- Prod: final production-like environment for approved changes only

### GitOps model

> Status: Pending / Not started
>
> GitOps controller setup, branch promotion flow, and automated sync enforcement are not yet configured or deployed.

The repository will be aligned to a GitOps workflow:
- Terraform and environment configuration live in Git
- application manifests or deployment configuration live in Git
- pull-based reconciliation is handled by Argo CD or Flux
- changes are reviewed by PR before deployment
- environment drift is detected through Git state and reconciliation status

### GitOps architecture pattern
- Source of truth: Git repository branches and tags
- Deployment controller: Argo CD or Flux
- Target environment: GCP-managed infrastructure and workloads
- Promotion path: Dev -> Test -> Staging -> Prod
- Observability: GitOps sync status, deployment health, and rollback indicators

### Current focus: DEV-first
For the first implementation phase:
- provision the DEV environment only
- validate GitOps flow for Terraform and workload delivery
- confirm secure service accounts, IAM, and networking patterns
- validate observability, logging, and message flow in the development environment
- then replicate the successful pattern to Test, Staging, and Prod environments

## GitOps checklist
- [ ] Git repository structure for IaC and application config
- [ ] Git branch strategy for environment promotion
- [ ] Argo CD or Flux installation and configuration
- [ ] Application and infrastructure sync manifests
- [ ] Environment-specific config overlays
- [ ] Automated validation for Terraform plans
- [ ] Automated deployment approval gates for promoted environments
- [ ] Rollback process for failed GitOps syncs
- [ ] GitOps health and drift monitoring
- [ ] Secret management integration for each environment

## Environment-specific readiness by phase
### Dev
- [ ] Secure baseline network and IAM
- [ ] Pub/Sub topics and message flow enabled
- [ ] Redis or Memorystore instance configured
- [ ] Observability tools enabled with trace IDs
- [ ] Terraform state and GitOps sync working

### Test
- [ ] Duplicate Dev environment configuration with stricter validation
- [ ] Integration and regression testing setup
- [ ] QA sign-off workflow

### Staging
- [ ] Production-like configuration checks
- [ ] Security and performance validation
- [ ] Smoke tests and release-readiness validation

### Prod
- [ ] Controlled deployment pipeline
- [ ] Approval gates and high-availability reference design
- [ ] Operational alerting and incident procedures

## Notes
- We are starting with the DEV environment to validate the project patterns before scaling the GitOps model across the remaining stages.
- The four-environment approach is intended to keep the project realistic while making the deployment workflow teachable and interview-ready.
- GitOps is used to drive environment consistency, repeatability, and operational traceability.

## Current repo-alignment notes

The checklist below remains broadly accurate for the project, but it should be updated to reflect the concrete service pattern the repo is describing:

- Salesforce remains the customer and sales interaction boundary.
- Mulesoft is the orchestration and transformation layer between CRM, hotel services, and event messaging.
- Pub/Sub is the primary asynchronous messaging backbone for inquiry and booking lifecycle events.
- Kafka may be used as an optional higher-throughput stream layer or integration pattern for event processing.
- GCP hosts the cloud-native runtime, managed services, networking, auth, monitoring, and IaC workflow.
- Redis/MemoryStore is a cache or transient-state layer, not the system of record.
- The project should model an operational source-of-truth for bookings and inventory, even if the mock implementation keeps it lightweight.

### Suggested GCP service mapping for this repo
- [ ] Cloud Run or GKE for API and event processing services
- [ ] Pub/Sub topics and subscriptions for lead, inquiry, availability, quote, and booking events
- [ ] Kafka or a managed streaming add-on where higher-throughput event processing is demonstrated
- [ ] Memorystore for Redis for cached availability and quote snapshots
- [ ] Cloud SQL, Spanner, or equivalent lightweight operational datastore for booking/operational records
- [ ] Cloud Monitoring + Cloud Logging + Cloud Trace for telemetry and flow health
- [ ] OpenTelemetry collectors or SDK instrumentation in all services
- [ ] Secret Manager for sensitive credentials and integration secrets
- [ ] Artifact Registry for container images and deployment artifacts
- [ ] IAM / Workload Identity / service accounts for least-privilege access
- [ ] VPC + private networking + firewall rules for internal service communication
- [ ] Cloud Build or GitHub Actions for CI/CD validation and image build pipeline
- [ ] Argo CD or Flux for GitOps delivery across environments
