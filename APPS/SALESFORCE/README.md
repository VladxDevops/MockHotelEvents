+++
title = "Salesforce Project"
domain = "salesforce"
topics = ["salesforce", "crm", "lead-management", "wedding-inquiry", "index"]
difficulty = "intermediate"
progressive_tier = "Tier 3"
parent = "DOCUMENTATION/INTERNAL/spects.md"
children = ["APPS/SALESFORCE/Agents.md", "APPS/SALESFORCE/crm-options-and-salesforce-setup.md", "APPS/SALESFORCE/data-model.md", "APPS/SALESFORCE/process-flow.md", "APPS/SALESFORCE/recommended-salesforce-object-model.md", "APPS/SALESFORCE/salesforce_details.md"]
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "APPS/REDIS/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/README.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Defines Salesforce CRM responsibilities, lead qualification, object modeling, and integration boundaries for wedding inquiries.
- Questions Answered: What does Salesforce own? Which objects, fields, and lifecycle stages support the inquiry flow?
- When to Retrieve: Working on salesforce context for the Hotel Events wedding inquiry platform.
- When NOT to Retrieve: Working on unrelated generated assets, dependency lockfiles, or implementation code that does not need documentation context.
-->
# Salesforce Project

## Purpose
Salesforce is the customer-facing sales and lead management layer for the mock hotel events planning project. It models the inquiry and qualification flow for a wedding request without being the source of truth for venue inventory or operational execution.

## Business flow
1. Prospect submits a wedding inquiry.
2. A Lead or Contact is created in Salesforce.
3. Sales qualifies the customer and creates an event request.
4. An Opportunity is created for the wedding or event.
5. Integration services validate dates, venue availability, and package pricing.
6. Quote and booking status are updated back in Salesforce.
7. Operational teams receive the confirmed booking handoff.

## Key objects
- Lead
- Contact
- Account
- Opportunity
- Event_Request__c
- Event_Quote__c
- Wedding_Package__c
- Venue_Availability__c
- Event_Booking__c

## Key integration points
- Mulesoft receives inquiry and event request data
- Pub/Sub or Kafka carries event-driven updates and status changes
- downstream systems handle venue, operations, and tracking logic

## Learning notes
This subproject is meant for learning by doing and should stay understandable and realistic without pretending to be a full production Salesforce implementation.

## Related documentation
- `process-flow.md` — end-to-end lifecycle flow
- `data-model.md` — mock object model
- `salesforce_details.md` — more detailed reference notes
- `Agents.md` — subproject guidance
- `../../DOCUMENTATION/INTERNAL/customer-landing-page.md` — landing page reference that feeds the inquiry flow
