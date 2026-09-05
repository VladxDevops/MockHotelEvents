+++
title = "Redis subproject — local dev"
domain = "caching"
topics = ["redis", "caching", "memorystore", "transient-state", "index"]
difficulty = "intermediate"
progressive_tier = "Tier 3"
parent = "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md"
children = []
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`cloud-infrastructure-checklist.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Documents Redis or Memorystore usage as a transient cache for availability, pricing, or session-oriented state.
- Questions Answered: What is cached in Redis, what is explicitly not cached, and how is transient state used safely?
- When to Retrieve: Working on caching context for the Hotel Events wedding inquiry platform.
- When NOT to Retrieve: Working on unrelated generated assets, dependency lockfiles, or implementation code that does not need documentation context.
-->
# Redis subproject — local dev

Overview
- This folder contains a minimal Redis environment and a heartbeat client used for connection smoke tests.

Files
- `docker-compose.yml` — starts `redis` and builds the client from `container/Dockerfile`.
- `cloud-run.yaml` — deployment template (update `image` and `REDIS_HOST`).
- `container/` — contains `Dockerfile`, `app.py` (heartbeat client), and `requirements.txt`.

Prerequisites
- Docker Engine / Docker Desktop installed and running.
- `docker` and `docker compose` available on your PATH.

Run locally (development)
1. Change to this directory:

```bash
cd SUBPROJECTS/REDIS
```

2. Build and start services (requires Docker daemon):

```bash
docker compose up --build
```

Notes
- The `docker-compose.yml` intentionally omits the deprecated top-level `version` key.
- The `app` in `container/app.py` is a simple heartbeat client that `PING`s Redis and logs status — it does not expose an HTTP API.
- If the Docker daemon is not running you will see an error like `failed to connect to the docker API ... /var/run/docker.sock`.

Cloud / CI
- `cloud-run.yaml` is a template for deploying a client to Cloud Run (replace `gcr.io/PROJECT/redis-client:latest` and `REDIS_HOST`).
- For managed Redis (Memorystore) use a Terraform module and VPC connector; do not expose Memorystore publicly.

Quick troubleshooting
- To stream logs after starting (in a separate terminal):

```bash
cd SUBPROJECTS/REDIS
docker compose logs -f
```

Contact
- If you want, I can convert the heartbeat client to a small HTTP service (`/ping`, `/set`, `/get`) for more interactive testing.
