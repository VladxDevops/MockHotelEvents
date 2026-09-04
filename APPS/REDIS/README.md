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
