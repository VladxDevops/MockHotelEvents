+++
title = "Kafka App Index"
domain = "messaging"
topics = ["kafka", "event-streaming", "schemas", "wedding-inquiry", "index"]
difficulty = "intermediate"
progressive_tier = "Tier 3"
parent = "DOCUMENTATION/INTERNAL/ARCHITECTURE/wedding-inquiry-event-schema.md"
children = []
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/wedding-inquiry-event-schema.md",
    "APPS/Mulesoft/README.md",
    "APPS/REDIS/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`wedding-inquiry-event-schema.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/wedding-inquiry-event-schema.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`Mulesoft/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/Mulesoft/README.md) | [`REDIS/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/README.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Serves as the Kafka application entry point for wedding inquiry event streaming documentation.
- Questions Answered: Where should Kafka topic, consumer, retry, and event-streaming docs live?
- When to Retrieve: Designing or documenting Kafka consumers, topic contracts, retry policy, or stream processing around wedding inquiries.
- When NOT to Retrieve: Working strictly on Salesforce object modeling, Redis cache TTLs, or Terraform provider bootstrapping.
-->

# Kafka App Index

This directory is reserved for Kafka-specific implementation artifacts and documentation for the Hotel Events wedding inquiry event stream.

## Contents

| File | Tier | Primary Topic |
| :--- | :---: | :--- |
| `README.md` | Tier 3 | Kafka app entry point and documentation routing |

## Dependencies & Upstream Services

Kafka consumes normalized wedding inquiry events produced by the integration layer and must follow the canonical event contract in `DOCUMENTATION/INTERNAL/ARCHITECTURE/wedding-inquiry-event-schema.md`.

## Recommended Reading Order

1. `DOCUMENTATION/INTERNAL/spects.md`
2. `DOCUMENTATION/INTERNAL/ARCHITECTURE/wedding-inquiry-event-schema.md`
3. `APPS/KAFKA/README.md`
