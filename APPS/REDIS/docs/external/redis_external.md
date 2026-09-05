+++
title = "Redis External Integration Guide"
domain = "external-docs"
topics = ["redis", "caching", "memorystore", "transient-state"]
difficulty = "intermediate"
progressive_tier = "Tier 3"
parent = "APPS/REDIS/README.md"
children = []
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "APPS/REDIS/README.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/README.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/README.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Contains external-facing or stakeholder-oriented documentation that should avoid internal-only implementation detail.
- Questions Answered: What stakeholder-facing changes or summaries are safe to share?
- When to Retrieve: Working on external docs context for the Hotel Events wedding inquiry platform.
- When NOT to Retrieve: Working on unrelated generated assets, dependency lockfiles, or implementation code that does not need documentation context.
-->
# Redis External Integration Guide

> **Path:** [Documentation Root](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION) > [Redis App](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/README.md) > External Guide

## Overview
This guide provides consumers of the Redis service with standard connection patterns, expected environment variables, and integration limits.

## Connecting to Redis
All microservices connecting to the Redis caching layer must utilize the standard environment variables to resolve connection parameters securely.

### Required Environment Variables
- `REDIS_HOST`: The host endpoint (e.g., Memorystore IP or local Docker container name).
- `REDIS_PORT`: Default is `6379`.
- `REDIS_PASSWORD`: Provided securely at runtime (never hardcoded in images).

### Example Client Usage (Python)
```python
import redis
import os

def get_redis_client():
    return redis.Redis(
        host=os.getenv("REDIS_HOST", "localhost"),
        port=int(os.getenv("REDIS_PORT", 6379)),
        password=os.getenv("REDIS_PASSWORD"),
        decode_responses=True
    )
```

## Consumer Responsibilities
- Do not store unencrypted PII in Redis.
- Prefer setting TTLS for all newly created keys to avoid Memory pressure.
- Avoid using `KEYS *` in production; utilize `SCAN` instead.
