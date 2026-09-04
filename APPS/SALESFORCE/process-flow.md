# Salesforce Event Process Flow

## Overview
This document outlines the expected customer and sales journey inside Salesforce for a wedding planning scenario in the mock hotel events project.

## High-level flow

1. Prospect submits inquiry
   - Source may be a website, wedding inquiry form, or direct sales outreach.
   - A new Lead is created in Salesforce.

2. Lead qualification
   - Sales team reviews the inquiry.
   - Event type, guest count, preferred dates, and budget are validated.
   - Lead is assigned to an event sales representative.

3. Event request creation
   - A custom `Event_Request__c` record is generated.
   - Event and wedding preferences are captured.
   - Wedding package or venue preference data is attached.

4. Opportunity creation
   - A related Opportunity is created or converted from the lead.
   - Sales stage moves from `New Inquiry` to `Qualified` and then to `Proposal`.
   - Revenue, date, and expected guest volume are stored.

5. Availability and quote validation
   - Mulesoft receives the event request and checks venue and room availability.
   - Pricing, catering, and service constraints are validated.
   - Salesforce receives the quote or fulfillment context.

6. Proposal presentation
   - Sales team produces a proposal or package summary.
   - Opportunity is updated with estimated pricing and response notes.

7. Contract and confirmation
   - If approved, a booking is created or the opportunity is marked as booked.
   - Operational teams are notified.
   - The wedding event is scheduled and flagged for execution.

8. Post-confirmation operations
   - Event staff receive operational details.
   - Monitoring and event logs continue tracking the lifecycle.

## Salesforce lifecycle states

| Stage | Description |
| --- | --- |
| New Inquiry | Initial lead or website inquiry record created |
| Qualified Lead | Prospect validated and assigned to sales |
| Discovery | Requirements and venue details captured |
| Proposal Prepared | Quote or package proposal created |
| Contract Review | Customer reviews terms and details |
| Booking Confirmed | Wedding event is accepted |
| Event Scheduled | Planning and operations teams receive handoff |
| Completed | Event execution finished |
| Lost | Inquiry did not convert |

## Data handoff points
### To Mulesoft
Salesforce sends structured business events and request payloads containing:
- lead or contact identity
- event request metadata
- preferred dates and venue choices
- guest count and budget
- relevant package or service interest

### From Mulesoft
Salesforce accepts responses including:
- venue availability result
- quote line-item data
- booking status updates
- operational readiness signals

## Event messages expected
- `lead.created`
- `lead.qualified`
- `event.request.created`
- `venue.availability.checked`
- `event.quote.generated`
- `event.booking.confirmed`
- `event.operations.handoff`

## Example application flow
A prospective couple asks for a Saturday wedding in the fall with 180 guests. Salesforce creates a Lead and a related Event_Request__c row. The event is qualified and assigned to the wedding sales manager. Mulesoft checks venue inventory and room block availability. A quote is generated and sent back to Salesforce. After approval, the opportunity status changes to Closed Won and the wedding booking is created for operational handoff.

## Operational considerations
- Sales users should be able to see the most recent status and quote summary without accessing internal pricing systems directly.
- Historical record changes should be visible for auditing and follow-up.
- The system should support campaign attribution and source tracking for event lead generation.
