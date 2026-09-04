# Starter Terraform / GCP Dev Architecture Plan

## Purpose
This document defines a minimal but realistic DEV environment for the hotel wedding inquiry architecture in this repository. The goal is to support the end-to-end workflow without overbuilding the first implementation: Salesforce captures the request, Mulesoft orchestrates processing, Pub/Sub or Kafka carries events, backend services validate availability and pricing, Redis provides short-lived cache state, and GCP hosts the runtime and observability stack.


## Architectural intent
This is not production architecture. It is a mock but enterprise-credible implementation meant to demonstrate:
- CRM-driven inquiry capture
- integration orchestration
- asynchronous event propagation
- cloud-native hosting
- observability and traceability
- environment-by-environment delivery patterns


## High-level flow
1. A wedding inquiry is created in Salesforce.
2. Salesforce or a connected service emits a lead or inquiry event.
3. Mulesoft normalizes and routes the payload.
4. A backend availability service validates dates and venue fit.
5. A pricing or quote service calculates package pricing.
6. Events are published to Pub/Sub and/or Kafka for asynchronous processing.
7. Redis caches short-lived availability or quote data.
8. GCP monitoring captures traces, logs, and error metrics for the whole path.


## Recommended GCP service map


### Network and platform
- VPC with app and data subnets
- Private Service Access for managed services if needed
- Firewall rules with least-privilege access
- NAT / egress controls if required


### Compute and application runtime
- Cloud Run for APIs and asynchronous processors
- Optional GKE if a container orchestration pattern is preferred later
- Artifact Registry for container images
- Cloud Build or GitHub Actions for CI/CD validation and image builds


### Messaging layer
- Pub/Sub topics for inquiry lifecycle events
- Kafka or equivalent streaming layer as an optional higher-throughput event option
- DLQ pattern for failed processing
- Retry and backoff configuration at the consumer boundary


### Data and cache layer
- Memorystore for Redis for cached availability and quote data
- Cloud SQL or Spanner for booking and operational state records
- Keep Redis as a cache only, not the system of record


### Security and identity
- Service accounts per app or component
- Workload Identity for secure service-to-service access
- Secret Manager for credentials and integration secrets
- IAM with least privilege


### Observability
- Cloud Logging
- Cloud Monitoring
- Cloud Trace
- OpenTelemetry instrumentation in all app and integration services
- Alerts on queue lag, API failures, and quote/booking failure rates


### GitOps and environment delivery
- Git repo as source of truth
- Argo CD or Flux for environment sync and drift monitoring
- DEV-first rollout followed by TEST, STAGING, PROD


## Core DEV components


### 1. Networking
- One VPC or shared network
- Dedicated subnets for application services and data services
- Firewall policy based on required internal traffic only
- Private access controls for managed service integrations


### 2. Messaging
Suggested topics:
- `wedding.lead.created`
- `wedding.inquiry.received`
- `wedding.availability.requested`
- `wedding.availability.responded`
- `wedding.quote.generated`
- `wedding.booking.confirmed`
- `wedding.operations.handoff`

Suggested characteristics:
- one subscription per consumer pattern
- DLQ topic per major subscription or worker pool
- message retention is short and development-friendly
- retry configuration is explicit and documented


### 3. Application services
The DEV environment should include a small set of services:
- inquiry intake API
- availability validation service
- quote/pricing service
- booking confirmation service
- operations handoff service

These can be implemented as Cloud Run services or lightweight containerized apps.


### 4. Data and cache
- Redis instance for availability and quote result caching
- lightweight database for operational records, such as Cloud SQL
- minimal booking state model for the mock event lifecycle


### 5. Monitoring and tracing
Each service should emit:
- HTTP request metrics
- error counts and retries
- queue lag or subscription lag metrics
- trace IDs and correlation IDs
- structured logs for inquiry and booking state transitions


## Recommended Terraform structure

```text
terraform/
  environments/
    dev/
      main.tf
      variables.tf
      outputs.tf
      terraform.tfvars
  modules/
    network/
    iam/
    pubsub/
    redis/
    database/
    monitoring/
    cloudrun/
    gitops/
```


## Proposed DEV resource inventory
- VPC and subnet resources
- Cloud Run services or lightweight containers
- Pub/Sub topics and subscriptions
- Dead-letter topics
- Memorystore Redis instance
- Cloud SQL or Spanner instance
- Service accounts and IAM bindings
- Secret Manager secrets
- Logging sinks and monitoring alert policies
- Artifact Registry repository
- GitOps deployment controller (Argo CD or Flux)


## Security baseline
The DEV environment should still enforce sensible protections:
- [ ] least-privilege service accounts
- [ ] Secret Manager for credentials
- [ ] private networking where practical
- [ ] TLS for service-to-service communication
- [ ] no broad public exposure of admin interfaces
- [ ] Terraform remote state with access controls
- [ ] environment-specific separation of configuration and secrets

## Observability baseline
The architecture should include:
- [ ] OpenTelemetry SDK instrumentation in app services
- [ ] trace propagation across Salesforce, Mulesoft, messaging, and backend services
- [ ] structured logs with `correlationId` and `eventId`
- [ ] latency charts for inquiry and quote processing
- [ ] queue lag and DLQ alerting
- [ ] a dashboard for booking flow health


## GitOps baseline
The project should align to a GitOps delivery model using Git as the source of truth:
- Terraform definitions live in Git
- environment values live in Git
- app manifests and deployment config live in Git
- Argo CD or Flux syncs the environment to the repo state
- drift detection and rollback are part of the operational pattern


## Phase-by-phase DEV rollout

### Phase 1: network and IAM
- Enable GCP services
- create VPC and subnets
- create service accounts
- configure IAM and Secret Manager
- confirm network isolation


### Phase 2: messaging
- create Pub/Sub topics and subscriptions
- configure DLQ topics
- validate event flow and redelivery behavior


### Phase 3: cache and data
- deploy Redis
- deploy minimal database for booking state
- create access patterns and TTL policies


### Phase 4: application services
- deploy inquiry intake service
- deploy availability validation service
- deploy quote service
- deploy booking confirmation service


### Phase 5: observability
- enable OpenTelemetry tracing
- configure logs and metrics dashboards
- add alerts for failures, retries, and queue backlog


### Phase 6: GitOps and release hygiene
- configure Argo CD or Flux
- validate sync behavior and drift detection
- establish rollback and deployment review process


## Minimal viable DEV architecture
If the team wants the smallest credible implementation, it should still include:
- one VPC
- one Redis instance
- one Pub/Sub topic set for event routing
- one optional Kafka layer for comparison or higher-throughput event demo
- one Mulesoft runtime or equivalent integration layer
- one or more Cloud Run services for inquiry, availability, and quote processing
- one database for booking state
- observability stack and IAM guardrails
- Terraform modules for repeatable infrastructure creation


## Recommended first implementation slice
The best first slice is:
- Salesforce lead / inquiry capture
- Mulesoft normalization and event emission
- Pub/Sub topic for `wedding.inquiry.received`
- quote-generation service
- basic Redis cache for quote results
- Cloud Logging and Trace for request visibility

This gives a clean, testable end-to-end flow without requiring a full production-like stack.


## Final recommendation
Use the DEV environment as the first real implementation target. It should be small enough to teach and debug, but complete enough to demonstrate a realistic wedding inquiry lifecycle from lead creation through quote generation and booking confirmation. Terraform should be used to provision this environment, GitOps should drive deployment behavior, and OpenTelemetry should provide end-to-end observability across the entire system.
