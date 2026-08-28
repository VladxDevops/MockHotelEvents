# Salesforce Data Model for Hotel Event Planning

## Purpose
This document outlines a proposed mock Salesforce data model for the hotel wedding planning scenario. It is intended as a practical starting point for implementation planning and integration design.

## Standard object usage
### Lead
Represents an initial inquiry or prospect.

Suggested fields:
- FirstName
- LastName
- Email
- Phone
- Company
- LeadSource
- EventType
- PreferredEventDate
- AlternateEventDate
- GuestCount
- BudgetRange
- Status
- Notes

### Contact
Represents the wedding couple, family contact, or primary decision-maker.

Suggested fields:
- Name
- Email
- Phone
- RelationshipType

### Account
Represents the customer or organizing party connected to the event.

Suggested fields:
- Account Name
- Billing Address
- Industry (optional)
- Customer Category

### Opportunity
Represents the sales opportunity for the event.

Suggested fields:
- Opportunity Name
- AccountId
- Close Date
- StageName
- Amount
- EventType
- WeddingDate
- GuestCount
- Probability
- OwnerId

## Custom objects
### Event_Request__c
Stores the specific event and wedding details.

Core fields:
- Name
- Lead__c
- Account__c
- Contact__c
- Opportunity__c
- Event_Type__c
- Wedding_Date__c
- Ceremony_Date__c
- Reception_Date__c
- Estimated_Guest_Count__c
- Venue_Preference__c
- Budget_Range__c
- Party_Size__c
- Catering_Requirements__c
- Room_Block_Required__c
- Status__c
- Notes__c

### Venue_Availability__c
Tracks availability feedback from inventory or venue validation services.

Fields:
- Event_Request__c
- Venue_Name__c
- Availability_Status__c
- Start_Date__c
- End_Date__c
- Capacity__c
- Block_Notes__c
- External_System_Id__c

### Wedding_Package__c
Captures package interest or package options selected by customer.

Fields:
- Name
- Event_Request__c
- Package_Type__c
- Included_Services__c
- Base_Price__c
- Status__c

### Event_Quote__c
Documents quote and pricing information produced by integration logic.

Fields:
- Event_Request__c
- Opportunity__c
- Quote_Number__c
- Total_Price__c
- Valid_Until__c
- Quote_Status__c
- CurrencyIsoCode
- Notes__c

### Event_Booking__c
Represents the confirmed booking or reservation after approval.

Fields:
- Opportunity__c
- Event_Request__c
- Booking_Status__c
- Booking_Date__c
- Total_Contract_Value__c
- Room_Block_Count__c
- Event_Operations_Notes__c

## Relationships
- One Lead can create one or more Event_Request__c records.
- One Event_Request__c can relate to one Opportunity.
- One Event_Request__c can have multiple Venue_Availability__c records.
- One Event_Request__c can have multiple Event_Quote__c records over time.
- One Opportunity can be linked to one Event_Booking__c after confirmation.

## Example record scenario
A prospect named Sarah and Daniel submits a wedding inquiry for a Saturday ceremony and reception in October. Salesforce creates:
- Lead: Sarah and Daniel inquiry
- Contact: primary couple contact
- Opportunity: Wedding Event Opportunity
- Event_Request__c: details for date, guest count, package preference, venue type
- Event_Quote__c: pricing generated after validation
- Event_Booking__c: created after contract approval and payment commitment

## Data governance notes
- Store only sales-relevant attributes in Salesforce; operational inventory remains in the hotel system or downstream services.
- Maintain clear status fields to avoid confusion between `lead`, `opportunity`, and `booking` lifecycle states.
- Capture integration IDs for traceability to downstream systems.
- Record timestamps and status changes for monitoring and reporting.

## Implementation assumptions
- This model is suitable for a mock but realistic demonstration.
- Custom object names are intentionally readable for enterprise-style architecture conversations.
- Field names may be adjusted to fit a specific Salesforce org configuration or data governance standards.
