+++
title = "Salesforce Subproject Agent Guide"
domain = "salesforce"
topics = ["salesforce", "crm", "lead-management", "wedding-inquiry"]
difficulty = "intermediate"
progressive_tier = "Tier 3"
parent = "APPS/SALESFORCE/README.md"
children = []
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "APPS/SALESFORCE/README.md",
    "APPS/REDIS/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/SALESFORCE/README.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/SALESFORCE/README.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Defines Salesforce CRM responsibilities, lead qualification, object modeling, and integration boundaries for wedding inquiries.
- Questions Answered: What does Salesforce own? Which objects, fields, and lifecycle stages support the inquiry flow?
- When to Retrieve: Working on salesforce context for the Hotel Events wedding inquiry platform.
- When NOT to Retrieve: Working on unrelated generated assets, dependency lockfiles, or implementation code that does not need documentation context.
-->
# Salesforce Subproject Agent Guide

## Purpose
This subproject is part of the learning-by-doing Hotel Events Planning repository. It models how a wedding inquiry moves through sales and CRM processes before being validated by other systems.

## Scope
Salesforce is the customer-facing sales layer. It should handle:
- lead capture
- customer and account records
- opportunity and event requests
- quote and booking status tracking
- handoff to integration and operations systems

## Key idea
Salesforce should not be the source of truth for final availability, inventory, or operational execution. It is the front-end to the sales process and the place where customer intent is captured and qualified.

## Lifecycle
1. Prospect submits inquiry
2. Lead is created or qualified
3. Event request is added
4. Opportunity is created
5. Mulesoft validates availability and pricing
6. Quote and booking status are updated
7. Operational teams receive the confirmed event handoff

## Key events
- `lead.created`
- `event.request.created`
- `event.availability.requested`
- `event.quote.generated`
- `event.booking.confirmed`
- `event.operations.handoff`

## Reference docs
- `README.md` — quick overview
- `process-flow.md` — lifecycle flow
- `data-model.md` — object model
- `salesforce_details.md` — detailed implementation notes
- `../../DOCUMENTATION/INTERNAL/customer-landing-page.md` — conceptual customer entry point
