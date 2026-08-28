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

### 2. Integration layer
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

## Documentation map
Start here:
- `DOCUMENTATION/INTERNAL/spects.md` — central project summary
- `DOCUMENTATION/INTERNAL/architecture-overview.md` — high-level architecture view
- `DOCUMENTATION/INTERNAL/interview-cheat-sheet.md` — quick interview-ready summary
- `DOCUMENTATION/INTERNAL/glossary.md` — key concepts and terminology
- `DOCUMENTATION/INTERNAL/roadmap.md` — learning roadmap and next steps
- `SUBPROJECTS/SALESFORCE/README.md` — Salesforce context and workflow
- `DOCUMENTATION/INTERNAL/customer-landing-page.md` — conceptual landing page reference
