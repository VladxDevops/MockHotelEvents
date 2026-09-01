+++
title = "Redis External Integration Guide"
type = "external-documentation"
status = "active"
ai_retrieval_triggers = ["redis connection guide", "redis external usage", "connecting to memorystore"]
+++

# Redis External Integration Guide

> **Path:** [Documentation Root](../../../DOCUMENTATION) > [Subprojects Context](../../) > Redis > External Guide

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
