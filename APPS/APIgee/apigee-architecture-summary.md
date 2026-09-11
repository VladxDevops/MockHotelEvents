# Apigee-based architecture for the hotel events platform

## Business context
The hotel events platform supports wedding and event inquiries from prospects. A customer inquiry flows from lead capture through validation, pricing, availability, and booking confirmation. The platform must expose secure, governed APIs while keeping integration logic modular and cloud-native.

## Proposed architecture
- Salesforce captures the initial event inquiry and stores lead/opportunity information.
- Apigee sits in front of the hotel event APIs as the gateway and policy enforcement layer.
- Apigee exposes endpoints such as:
  - `/events/inquiries`
  - `/events/availability`
  - `/events/pricing`
  - `/events/quotes`
  - `/events/bookings`
- Apigee handles:
  - authentication and authorization
  - rate limiting and quotas
  - request validation
  - payload transformation
  - backend routing
  - caching
  - API analytics and monitoring
- Backend services in GCP process the actual business logic:
  - availability service
  - pricing service
  - catering and room package service
  - booking orchestration service
- Pub/Sub or Kafka is used for asynchronous event-driven processing:
  - `inquiry.created`
  - `availability.checked`
  - `quote.generated`
  - `booking.confirmed`
  - `operations.handoff`
- Redis stores transient data such as availability snapshots, pricing cache, or session context.
- GCP Monitoring and OpenTelemetry provide traceability, latency, and system health visibility across the event flow.

## Why this is a valid alternative to MuleSoft for this project
In this scenario, Apigee is used for:
- secure external API exposure
- policy enforcement
- API composition and routing
- partner/client-facing integration governance

It does not need to replace every enterprise integration function. Instead, it can effectively handle the API layer while the backend business workflows remain in cloud-native services. That makes the architecture more modern, modular, and easier to reason about for a GCP-focused role.

## Can Apigee orchestrate APIs?
Yes. Apigee can orchestrate API calls and compose responses. For example:
- call the customer profile service
- call the venue availability service
- call the pricing service
- combine the results into one response for the front-end or CRM
- apply security and transformation policies before returning the data

This is especially useful when the project needs a clean API façade and centralized policy management.

## Interview-ready summary
“We designed the wedding event platform using Apigee as the API management and orchestration tier rather than treating it as a full replacement for MuleSoft. Apigee exposes secure, controlled endpoints for inquiries, availability checks, quote generation, and bookings. It enforces security, quotas, transformations, and routing, while backend GCP services handle business rules, pricing, and event processing. Pub/Sub and Redis are used for asynchronous event handling and fast caching, and monitoring is built in with OpenTelemetry and GCP observability. This gives us a clean, enterprise-grade API layer without forcing the entire platform into a single integration platform.”

## Short positioning statement
Apigee is not a full replacement for MuleSoft in every enterprise integration scenario, but for this project it is a strong alternative for the API management and orchestration layer. It provides the secure, governed, scalable interface needed to expose wedding event APIs while allowing the platform to remain modular, event-driven, and cloud-native.

## Lowest-hanging fruit for this project
The fastest and most defensible way to use Apigee here is to start with the API layer and keep the business logic in backend services. This gives a quick win without pretending Apigee replaces the full enterprise integration platform.

- Expose a single, secure API for event inquiries and availability checks.
- Create an Apigee proxy for `/events/inquiries` and `/events/availability` first.
- Enforce auth, rate limits, quotas, and request validation at the gateway.
- Route requests to backend services running in GCP such as Cloud Run or Cloud Functions.
- Transform the Salesforce payload into the internal event schema before calling downstream services.
- Publish `inquiry.created` and `booking.confirmed` events to Pub/Sub after successful orchestration.
- Cache frequent availability and pricing responses in Redis to reduce repeated backend calls.
- Add OpenTelemetry tracing and Apigee analytics to measure latency, failures, and usage patterns.

This is the lowest-hanging fruit because it delivers secure API exposure, centralized policy enforcement, and a clean event-driven backend with minimal architecture risk while still aligning with a realistic enterprise pattern.
