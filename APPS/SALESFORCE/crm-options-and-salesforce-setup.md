# CRM Options and Salesforce Setup Notes

## Salesforce options

### Salesforce Developer Edition
- Free
- Intended for learning, prototyping, and testing
- Best fit for this project and mock enterprise architecture work
- Not intended for production use
- Includes core CRM functionality, APIs, and development tooling

### Salesforce trial or evaluation orgs
- Sometimes available for a limited-time product trial
- Typically a short evaluation window, such as 14–30 days
- Useful for testing paid features or a specific Salesforce cloud
- Not a long-term free option

### Paid Salesforce editions
- Required for real production deployment
- Pricing depends on edition, user count, and add-ons
- Used for full enterprise CRM functionality in live environments

## What you need to start using Salesforce

- A Salesforce account
- Sign up for a Salesforce Developer Edition org
- Verified email address
- Basic org configuration
  - org name and domain
  - user permissions
  - profile and role setup
  - initial object configuration
- For project/integration work, you may also need:
  - OAuth app / connected app configuration
  - API access for REST or SOAP integrations
  - service account or integration user
  - security token or OAuth client credentials
  - custom fields or custom objects for event workflow data

## Recommended Salesforce setup for this project

For the hotel event planning scenario, a Developer Edition org is a practical fit.

Suggested objects and concepts:
- Lead
- Contact
- Account
- Opportunity
- Event Inquiry or custom object for wedding request details
- Custom fields for:
  - event date
  - guest count
  - venue preference
  - wedding type
  - package interest
  - room block size
  - budget range
  - sales owner

## Salesforce integration notes

If integrating Salesforce with Mulesoft or a custom backend, you will likely need:
- Salesforce API access
- OAuth setup
- integration user permissions
- field mapping between CRM objects and business event payloads
- event message contracts for actions like:
  - lead.created
  - event.inquiry.received
  - event.availability.requested
  - event.quote.generated
  - event.booking.confirmed

## Other CRM options with free or open-source access

### HubSpot CRM
- Free tier available
- Good for lead tracking, deals, and basic automations
- Easy to use for rapid demos
- Not open source, but free to start

### Zoho CRM
- Free plan exists for smaller teams
- Includes lead and deal management
- Useful for a lightweight CRM workflow

### Bitrix24
- Free plan available
- Includes CRM, communication, tasks, and some automation
- Flexible for small-team use cases

### SuiteCRM
- Open source and self-hosted
- Similar to Salesforce in spirit
- Good if you want a free CRM with customization and local hosting

### Odoo CRM
- Open source community edition
- Good if you want CRM plus broader business-process capabilities
- Useful when integrating many ERP or operational workflows

### EspoCRM
- Open source and lightweight
- Easier to self-host than large enterprise CRMs
- Good for smaller or simpler CRM implementations

## Best fit by scenario

### Best choice for a realistic enterprise-style mock project
- Salesforce Developer Edition

### Best quick-start free option
- HubSpot CRM

### Best open-source option
- SuiteCRM

## Recommendation for this repository

For the Hotel Events Planning project, the best path is:
1. Use Salesforce Developer Edition for the enterprise-style CRM story
2. Model the wedding inquiry as a lead or custom event inquiry workflow
3. Use integrations to push inquiry data into Mulesoft and downstream systems
4. Keep the architecture mock but realistic and interview-ready

If a free or open-source option is preferred, use:
- HubSpot CRM for user-friendliness and quick demos
- SuiteCRM or Odoo for self-hosted/open-source experimentation

## Summary

Salesforce does offer a free learning path through Developer Edition, which makes it ideal for this project. For production, a paid edition is required. For teams that want a free SaaS alternative, HubSpot is the easiest option; for free self-hosting, SuiteCRM and Odoo are strong choices.
