+++
title = "Salesforce Detailed Planning Notes"
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
# Salesforce Detailed Planning Notes

## Overview
This document provides a more detailed implementation view for the Salesforce portion of the mock Hotel Events Planning project. It expands on the overview and acts as a practical reference for architecture, integration, and demo planning.

## Business problem to solve
The hotel needs a way to capture wedding-related event inquiries from prospective clients, qualify them through a sales process, and route them into a broader event-planning and operations workflow. The Salesforce implementation should be realistic enough to show how a hotel can manage an event opportunity without turning Salesforce into the single source of truth for all hotel operations.

## Customer journey in Salesforce
A prospective couple wants to plan a wedding at the hotel.

The journey in Salesforce:
1. Prospect fills out a wedding inquiry form or is contacted by sales.
2. Salesforce creates a Lead or Account/Contact combination.
3. The sales team qualifies the customer and determines intent, budget, and date preferences.
4. A custom event request is created with wedding details, guest count, venue preferences, and package interest.
5. An Opportunity is created for the event and routed through the sales pipeline.
6. Salesforce triggers or shares the request with Mulesoft for availability and quote validation.
7. Pricing and venue availability are returned to Salesforce.
8. If accepted, the opportunity advances to booking or contract stage.
9. Operational teams receive the booking confirmation and begin execution planning.

## Role of Salesforce in the architecture
Salesforce is best viewed as:
- the CRM system of engagement
- the sales and opportunity management layer
- the primary customer-facing record holder for inquiries
- the integration boundary for outbound business events

It is not the source of truth for:
- venue availability
- room inventory
- event operations planning
- catering and staffing scheduling
- final pricing decisions from hotel systems

## Proposed object map
### Objects and responsibilities
- Lead: initial inquiry capture
- Account: customer organization or couple household record
- Contact: primary decision-maker/contact
- Opportunity: event deal or wedding booking pipeline
- Event_Request__c: detailed event requirements and preferences
- Event_Quote__c: price proposal generated after validation
- Wedding_Package__c: package choices and included services
- Venue_Availability__c: venue validation and availability checks
- Event_Booking__c: confirmed event after signing or approval

## Key event metadata to capture
For a mock but realistic Salesforce implementation, store the following metadata:
- inquiry source
- event type
- preferred and alternate dates
- guest count estimate
- ceremony and reception timing
- estimated budget
- room block requirement
- package or service preference
- current stage and owner
- timestamps for stage changes

## Proposed stages and expected status changes
### Inquiry stage
- New Inquiry
- Qualified Lead
- Discovery Call Scheduled

### Sales stage
- Proposal in Progress
- Proposal Sent
- Contract Review
- Needs Follow-up

### Booking stage
- Booking Confirmed
- Event Scheduled
- Completed
- Lost / Cancelled

## Data quality expectations
To support integration and demo use cases, Salesforce data should be:
- complete enough to initiate downstream validation
- consistent in status naming
- traceable through IDs and timestamps
- structured for integration payloads
- aligned with event lifecycle semantics

## Integration contract assumptions
Salesforce should expose a structured payload to Mulesoft including:
- lead/contact identifiers
- opportunity and event request identifiers
- wedding date and alternate dates
- guest counts and budget
- venue requirements
- package and catering needs
- source system metadata

Mulesoft should return:
- availability status
- quote or estimated pricing
- room inventory response
- confirmation or rejection outcome
- operational handoff details where applicable

## Event publication pattern
Salesforce should be capable of emitting business events such as:
- `lead.created`
- `lead.qualified`
- `event.request.created`
- `event.availability.requested`
- `event.quote.generated`
- `event.booking.confirmed`
- `event.operations.handoff`

These messages can be routed to Pub/Sub and/or Kafka to maintain asynchronous decoupling.

## Example mock scenario
Customer profile:
- Prospect: Sarah & Daniel
- Event Type: Wedding
- Prefered venue: Outdoor garden or ballroom
- Guests: 180
- Budget: $25k-$40k
- Preferred date: October 18, 2027

Salesforce flow:
1. New Lead created from website form.
2. Sales rep qualifies the couple.
3. Custom `Event_Request__c` record created.
4. Opportunity created and stage set to `Proposal in Progress`.
5. Request sent to Mulesoft.
6. Optical or venue check returns availability.
7. Quote is generated and attached to `Event_Quote__c`.
8. If accepted, `Event_Booking__c` is created and operations handoff begins.

## Implementation guidance for future work
- Make field names consistent with enterprise standards.
- Keep API objects lightweight and easy to map across integration layers.
- Include status and record owner fields to support sales operations visibility.
- Maintain traceable IDs for downstream systems and telemetry correlation.
- Design for easy demonstration of an end-to-end event lifecycle.

## Success criteria for Salesforce design
The Salesforce model is successful when it can:
- ingest and manage wedding inquiries in a realistic way
- create a clear opportunity path with event-specific details
- support downstream Mulesoft integration without excessive custom logic
- provide proper event metadata for observability and status tracking
- enable a clean business story from lead to booking
