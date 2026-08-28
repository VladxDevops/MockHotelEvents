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
