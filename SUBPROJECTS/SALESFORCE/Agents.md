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
