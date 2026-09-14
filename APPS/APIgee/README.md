+++
title = "Apigee Subproject — API Gateway & Management Index"
domain = "api-management"
topics = ["apigee", "api-gateway", "northbound", "orchestration", "security", "index"]
difficulty = "intermediate"
progressive_tier = "Tier 3"
parent = "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md"
children = ["APPS/APIgee/apigee-architecture-summary.md"]
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md",
    "PLATFORM/PROVIDERS/GCP/DEV/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Provides the directory index and documentation routing for Apigee X API management in the Hotel Events platform.
- Questions Answered: How is Apigee structured, what documentation exists, and how does it connect to Terraform and backend services?
- When to Retrieve: Working on API gateway, edge routing, proxy design, or Apigee architecture context.
- When NOT to Retrieve: Working on unrelated database schemas, Dockerfiles, or Kafka streaming specifics.
-->

# Apigee Subproject — API Gateway & Management Index

This directory index routes maintainers and AI agents to Apigee documentation, architectural design notes, and integration patterns for the Hotel Events platform.

## Contents

| File | Tier | Primary Topic |
| :--- | :---: | :--- |
| `apigee-architecture-summary.md` | Tier 3 | Apigee Architecture Summary, Positioning vs MuleSoft, and Endpoint Specifications |

## Connected Platform Infrastructure

The infrastructure-as-code deployment for Apigee X is maintained under the GCP Platform layer:
- [`PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md) — Root Terraform codebase for Apigee X (Evaluation)
- [`PLATFORM/PROVIDERS/GCP/TERRAFORM/MODULES/APIgee/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/MODULES/APIgee) — Reusable Terraform Apigee module
- [`PLATFORM/PROVIDERS/GCP/TERRAFORM/sample-proxy/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/sample-proxy) — Sample mock hotel events API proxy bundle
- [`PLATFORM/PROVIDERS/GCP/TERRAFORM/deploy-proxy.sh`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/deploy-proxy.sh) — Automated Apigee Management API proxy deployment script
- [`PLATFORM/PROVIDERS/GCP/TERRAFORM/test-apigee.sh`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/test-apigee.sh) — Automated curl smoke test runner

## Role in the Architecture

Apigee sits at the perimeter (Northbound) of the Hotel Events architecture:
1. **API Façade**: Exposes `/v1/events/inquiries`, `/v1/events/availability`, `/v1/events/pricing`, and `/v1/healthz`.
2. **Policy Enforcement**: Enforces API keys, OAuth 2.0 tokens, Spike Arrest, Quota management, and request schema validation.
3. **Ingress Routing**: Accepts traffic via a Regional External Application Load Balancer through Private Service Connect (PSC) NEG.
4. **Backend Integration**: Forwards validated, normalized requests to GCP backend services (Cloud Run / Cloud Functions) or MuleSoft integration flows.
