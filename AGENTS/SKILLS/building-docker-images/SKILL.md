---
name: building-docker-images
description: |
  Builds secure, minimal, maintainable container images for application services.

  Use this skill whenever you need to create or update Dockerfiles, container
  images, or containerized runtime guidance. It focuses on multi-stage builds,
  small final images, reduced attack surface, and non-root execution.

  This skill explicitly references the DockerIgnore-Builder skill for build-context
  hygiene and security. It also uses current repo examples in the Bank projects as
  implementation baselines.
license: Apache-2.0
metadata:
  version: v1
  publisher: google
---

# Docker Image Build Skill

## Quick answer

Use this skill when the task is to create or update a container image, Dockerfile, or runtime packaging approach.

Default rule:
- Build in stages.
- Keep the final image small.
- Reduce build-context exposure with `.dockerignore`.
- Run as a non-root user.

If the task is only to build a container image, the minimum correct pattern is:
1. Use a builder stage for dependencies and compilation.
2. Copy only runtime artifacts into the final stage.
3. Exclude secrets and unnecessary files via `.dockerignore`.
4. Create and switch to a dedicated non-root user.
5. Keep the image free of package manager caches and build tooling.

---

## When to use this skill

Use this skill when:
- a `Dockerfile` must be created or updated
- a service needs to be containerized
- the task involves image size, security, or runtime hardening
- the task requires a secure container pattern for a new project or service
- the user asks for Docker best practices or a lightweight image design

This skill is intended to complement the existing `.dockerignore` guidance and repository examples.

---

## Decision path

### Short version

If you need the shortest safe answer:
- Prefer a multi-stage `Dockerfile`.
- Use a slim runtime base image.
- Copy only the application and required runtime artifacts.
- Use `.dockerignore` to exclude secrets and unnecessary files.
- Run as a non-root user.

### Deeper version

If the task is more than a quick scaffold, follow these rules:

1. Builder stage
   - install build dependencies only here
   - compile or install runtime dependencies here
   - avoid copying the full workspace into the final image

2. Runtime stage
   - copy only the final runtime files
   - keep only minimal runtime libraries and app code
   - remove package manager caches and build tools

3. Security and hardening
   - check for `.dockerignore` before building
   - if missing or weak, generate or tighten it first
   - ensure credentials, `.env`, local keys, logs, and dev artifacts are excluded
   - create a dedicated non-root user and switch with `USER`

4. Runtime correctness
   - set `WORKDIR`
   - set relevant environment variables
   - prefer explicit `COPY` and `CMD` or `ENTRYPOINT` usage
   - avoid broad `COPY . .` in runtime images unless absolutely necessary

---

## Required baseline

### Multi-stage build pattern

```dockerfile
FROM python:3.11-slim AS builder
WORKDIR /build
COPY requirements.txt ./
RUN python -m venv /opt/venv && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

FROM python:3.11-slim AS runtime
WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
COPY src/ /app/src/
USER appuser
CMD ["python", "src/app.py"]
```

This pattern is already reflected in the Bank projects:
- `BNKprojects/5/Dockerfile` uses a builder stage and slim runtime stage.
- `BNKprojects/1/container/Dockerfile` builds an optimized runtime in a stage and copies only the final runtime into the container.

### `.dockerignore` requirement

Before writing or reviewing a Dockerfile, check whether `.dockerignore` is present and appropriate.

If it is missing or weak, use the existing `.dockerignore` guidance first. This reduces the build context and lowers the attack surface.

Required rule:
- exclude secrets, credentials, `.env`, keys, logs, build outputs, dev artifacts, and unrelated files
- do not copy source directories that are not required at runtime

This is not optional security hygiene; it is part of a secure image build.

### Non-root runtime requirement

Containers should run as a dedicated non-root user rather than `root`.

Example:

```dockerfile
RUN groupadd -g 10001 appgroup && \
    useradd -r -u 10001 -g appgroup appuser

WORKDIR /app
RUN chown -R appuser:appgroup /app
USER appuser
```

Repository examples:
- `BNKprojects/5/Dockerfile` creates an explicit `appuser` and switches to it.
- `BNKprojects/1/container/Dockerfile` uses `USER keycloak` for the final runtime.

---

## Recommended Dockerfile practices

### 1. Pin base images

Prefer explicit versions over floating tags.

Examples:
- `python:3.11-slim` is better than `python:latest`
- `quay.io/keycloak/keycloak:24.0.1` is a pinned runtime example

### 2. Remove build cache and package manager artifacts

```dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*
```

### 3. Avoid unnecessary files

Use explicit copy operations instead of copying broad directories.

```dockerfile
COPY src/ /app/src/
COPY requirements.txt ./
```

### 4. Prefer `COPY --chown`

```dockerfile
COPY --from=builder --chown=appuser:appgroup /opt/venv /opt/venv
```

This reduces ownership drift and permission problems.

### 5. Runtime configuration

- set `WORKDIR`
- set relevant runtime variables such as `PYTHONUNBUFFERED=1` and `PYTHONDONTWRITEBYTECODE=1`
- prefer clear `ENTRYPOINT`/`CMD` patterns when the container acts as a service

### 6. Keep secrets out of the image

- never bake secrets into the Dockerfile
- use environment variables or mounted secrets at runtime
- do not store `.env`, keys, private certificates, or credentials in the image

---

## Improvements to suggest for this repo

Apply these improvements when reviewing or generating Dockerfiles in the Bank repo:

1. Add explicit `.dockerignore` files where they are missing.
2. Keep the final runtime image free of build tooling and package caches.
3. Use dedicated non-root users consistently in all container images.
4. Prefer `COPY --chown` to reduce permission problems.
5. Add `HEALTHCHECK` where the application exposes a health endpoint.
6. Pin base image versions instead of using floating tags.
7. Keep `ENTRYPOINT` and `CMD` consistent across Compose and Dockerfile definitions.
8. Ensure writable directories are owned by the app user.
9. Avoid broad `COPY . .` in runtime stages unless there is no safer alternative.
10. Keep a clean separation between builder and runtime stages.

---

## Decision rule

When creating or updating a Docker image:

1. Check for `.dockerignore` and apply the repo guidance.
2. Use a multi-stage build.
3. Create a dedicated non-root runtime user.
4. Remove build tools and caches from the final image.
5. Keep the runtime stage minimal and production-safe.

---

## Examples to use as baseline



Use these examples as the baseline for future project7 MuleSoft container work:
- multi-stage build
- minimal final image
- no root execution
- `.dockerignore` first
- explicit ownership and user switching

---

## Final principle

The most important rule is simple: build lean, run unprivileged, and keep the image free of unnecessary attack surface.
