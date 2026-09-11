+++
title = "Hotel Events Planning - Main Agent Guide"
domain = "repository-index"
topics = ["core-specs", "wedding-inquiry", "requirements", "routing"]
difficulty = "intermediate"
progressive_tier = "Tier 1"
parent = ""
children = []
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "APPS/SALESFORCE/README.md",
    "APPS/REDIS/README.md",
    "APPS/APIgee/README.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/SALESFORCE/README.md)  
> **Progressive Tier**: Tier 1

<!-- AI RETRIEVAL HINTS:
- Purpose: Provides internal project knowledge for the Hotel Events wedding inquiry architecture, interview readiness, and implementation planning.
- Questions Answered: What internal knowledge should be loaded before deeper component work?
- When to Retrieve: Working on repository index context for the Hotel Events wedding inquiry platform.
- When NOT to Retrieve: Working on unrelated generated assets, dependency lockfiles, or implementation code that does not need documentation context.
-->
# Hotel Events Planning - Main Agent Guide

## Purpose
This repository is the main working definition for a mock hotel events planning project. The goal is to model a realistic end-to-end customer journey for planning and booking an event at a hotel, with a strong emphasis on integration patterns, event-driven architecture, and cloud-native operations.

This repository should be treated as the canonical source of truth for planning, implementation, and automation work related to the project.

## Example business story
A customer prospect wants to schedule dates for his or her wedding at the hotel.

The scenario includes:
- capturing the prospect in Salesforce
- validating venue availability and preferred dates
- checking packages, rooms, catering, and pricing options
- coordinating internal approvals and sales follow-up
- creating a booking or opportunity once the event is confirmed
- notifying downstream systems and operational teams
- tracking the lifecycle of the event from inquiry to execution

## Project scope
The project is not meant to be a production hotel system. It is a mock, realistic implementation that demonstrates how a hospitality business can integrate customer data, event workflows, and operational systems using common enterprise tools and cloud services.

The project should reflect a scenario where a hotel can:
- manage event inquiries and lead capture
- understand customer intent
- coordinate room and venue availability
- orchestrate internal and external system communication
- monitor the health of the event workflow end to end

## Core technology stack
The stack for this project includes:
- Salesforce for CRM, leads, opportunities, and customer relationship management
- Apigee X for API gateway management, rate limiting, and Northbound ingress routing
- Mulesoft for integration orchestration and API connectivity
- Pub/Sub for asynchronous event-driven messaging in GCP
- Kafka for event streaming and distributed processing patterns
- Terraform for infrastructure as code
- Google Cloud Platform (GCP) for hosting and cloud services
- GCP Monitoring with OpenTelemetry for observability, tracing, and metrics
- Redis / Memorystore for caching, temporary session data, and fast retrieval

## Desired architecture patterns
The solution should follow enterprise-grade architecture patterns suitable for a mock but realistic hotel booking and event planning workflow.

### 1. Customer and sales flow
- Prospect inquiry is created or captured in Salesforce.
- Sales teams review and qualify the event request.
- Opportunity or event request data is passed into integration layers.
- Availability and event requirements are validated against hotel resources.

### 2. API gateway and integration layer
- Apigee X serves as the Northbound API gateway, enforcing authentication, quotas, Spike Arrest, and routing.
- Mulesoft should orchestrate business flows between CRM and internal systems.
- APIs should be defined for event inquiry, availability, venue check, quote generation, and booking confirmation.
- Data transformations should be explicit and documented.

### 3. Event-driven communication
- Pub/Sub and Kafka should be used to decouple systems.
- Key events may include:
  - lead created
  - inquiry received
  - room availability checked
  - quote generated
  - booking confirmed
  - event reminder scheduled
  - operational handoff triggered

### 4. Cloud-native implementation
- GCP is the target cloud platform.
- Terraform should be used to provision and manage infrastructure reproducibly.
- Services should be modular and environment-aware.
- Security, IAM, and environment isolation should be considered from the start.

### 5. Monitoring and observability
- OpenTelemetry should be used to instrument services and propagate trace context.
- GCP monitoring tools should capture metrics, logs, traces, and alerting signals.
- Event processing flows should be observable from the customer inquiry through downstream processing.

### 6. Performance and session handling
- Redis / Memorystore should be used for fast retrieval of cached availability, pricing, or temporary state.
- Cache responsibilities should be clearly separated from source-of-truth systems.
- The project must avoid treating Redis as the only system of record.

## High-level workflow example
A wedding inquiry should travel through the system in a realistic flow:

1. A prospect submits a wedding event request.
2. Salesforce creates or updates the customer record and opportunity.
3. Mulesoft receives the request and normalizes the data.
4. Event availability is checked against room inventory, date availability, and service constraints.
5. A message is published via Pub/Sub or Kafka for asynchronous processing.
6. Downstream services validate pricing, staffing, and hotel operational readiness.
7. A quote or proposal is prepared and returned to the sales process.
8. If confirmed, the event is booked and operational teams are notified.
9. Redis caches relevant booking context for speed and responsiveness.
10. Observability tools capture latency, success, failure, and SLA signals for the entire flow.

## Repository expectations
This repository should support the following workstreams:
- architecture and system design documentation
- integration flow definitions
- Terraform infrastructure definitions
- event schemas and message contracts
- API and workflow examples
- monitoring and observability configuration
- mock data and sample use cases

## Coding and implementation guidance for agents
When creating or modifying code in this repository, prioritize these rules:
- Keep the project scenario grounded in hotel event planning and wedding scheduling.
- Prefer event-driven and loosely coupled integration patterns.
- Treat Salesforce and other external systems as integration boundaries, not as the only source of truth.
- Use Terraform for infrastructure configuration and environment provisioning.
- Ensure telemetry is emitted consistently with OpenTelemetry and GCP observability tooling.
- Document assumptions clearly when modeling availability, pricing, or booking logic.
- Keep mock examples realistic and easy to understand for enterprise integration scenarios.

## Success criteria
The repository should be considered successful when it can reasonably demonstrate:
- a mock customer prospect journey for a wedding booking
- a clear flow between Salesforce, integration, messaging, and cloud services
- realistic use of Pub/Sub, Kafka, Mulesoft, Terraform, GCP, monitoring, and Redis
- observable event processing with operational context
- a practical architecture story suitable for demos, design discussions, or implementation planning

## Operating principle
This project should be treated as a mock enterprise hospitality integration scenario that demonstrates modern data and service integration practices while remaining easy to reason about and extend.

## Project skill
The repository-specific skill for this project is located at:
- `AGENTS/SKILLS/MAIN-PROJECT-SKILL/skill.md`

Use this skill as the default working guide for architecture decisions, repository context, and interview-ready reasoning for the hotel wedding inquiry flow.

## Interview prep skill
A reusable DevOps interview preparation skill is also available here:
- `AGENTS/SKILLS/INTERVIEW-PREP-SKILL/skill.md`

Use it as a role-prep template whenever a DevOps or platform job description is received. It helps convert the JD into a study plan, architecture answer bank, and practical repo-based learning path.

## Progressive disclosure skill
The context engineering and knowledge architecture skill for this project is located at:
- `AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/SKILL.md`

Use this skill when refactoring docs, organizing cross-service knowledge, managing the control plane (`AI_MANIFEST.toml`), or loading targeted context tiers for AI agents.

## Context and progressive disclosure protocol
Before generating or modifying code or documentation:
1. Identify the relevant project domain (Salesforce, MuleSoft, Kafka, Redis, Terraform).
2. Follow the 4-tier progressive disclosure model (`AI_MANIFEST.toml` and `AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/`).
3. Load only the minimum required tier for the current task (Tier 1 -> Tier 2 -> Tier 3).
4. Follow documentation breadcrumbs before performing broad searches.
5. Do not read entire documentation trees unless explicitly necessary.
6. Create or update documentation according to the same navigation, TOML metadata, and retrieval conventions.

## Documentation map
Start here:
- `AI_MANIFEST.toml` — machine-readable knowledge base control plane
- `DOCUMENTATION/INTERNAL/spects.md` — central project summary
- `DOCUMENTATION/INTERNAL/architecture.md` — detailed architecture reference
- `DOCUMENTATION/INTERNAL/architecture-overview.md` — high-level architecture view
- `DOCUMENTATION/INTERNAL/security.md` — security-first design guidance
- `DOCUMENTATION/INTERNAL/interview-cheat-sheet.md` — quick interview-ready summary
- `DOCUMENTATION/INTERNAL/glossary.md` — key concepts and terminology
- `DOCUMENTATION/INTERNAL/roadmap.md` — learning roadmap and next steps
- `APPS/SALESFORCE/README.md` — Salesforce context and workflow
- `APPS/APIgee/README.md` — Apigee API gateway architecture and management index
- `DOCUMENTATION/INTERNAL/customer-landing-page.md` — conceptual landing page reference
- `AGENTS/SKILLS/MAIN-PROJECT-SKILL/skill.md` — repository-local project skill
- `AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/SKILL.md` — progressive disclosure context engineering skill
- `PLATFORM/PROVIDERS/GCP/README.md` — GCP infrastructure index
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md` — Apigee X Terraform infrastructure and deployment index
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md` — Terragrunt multi-environment implementation
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md` — Infrastructure folder organization and responsibilities

## Practice and interview prep
Use the repo as a working lab, not only as a document set:
- `DOCUMENTATION/INTERNAL/Tech-interview-Questions/QandAs.md` — architecture Q&A bank
- `DOCUMENTATION/INTERNAL/practice-lab.md` — hands-on exercises for implementing the patterns behind the questions
- `DOCUMENTATION/INTERNAL/roadmap.md` — learning progression and next tasks

The objective is to learn by designing, testing, and explaining realistic flows instead of only studying theory.

## Infrastructure checklist
The current project expects a realistic mock cloud footprint. The infrastructure plan is documented here:
- `TERRAFORM/cloud-infrastructure-checklist.md`

This checklist covers messaging, Redis, observability, security, networking, and Terraform requirements for the existing architecture.

## Environment and delivery model
The project will use a four-stage environment model:
- DEV
- TEST
- STAGING
- PROD

For the current phase, we are focusing on the DEV environment first. The remaining environments will follow the same architecture and delivery principles but will add stricter validation, promotion gates, and operational controls.

The repository will also follow a GitOps delivery approach using Git as the source of truth, with declarative infrastructure and deployment state managed through a GitOps controller such as Argo CD or Flux.

This means:
- infrastructure and configuration changes are made through Git
- deployment promotion follows an environment path
- drift and sync health are continuously monitored
- rollback and environment consistency are treated as first-class concerns
