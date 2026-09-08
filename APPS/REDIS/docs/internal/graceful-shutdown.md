+++
title = "Graceful Shutdown for the Redis Client and Cloud Run"
domain = "caching"
topics = ["redis", "cloud-run", "graceful-shutdown", "signals", "reliability"]
difficulty = "beginner"
progressive_tier = "Tier 3"
parent = "APPS/REDIS/docs/internal/README.md"
children = []
related = [
    "APPS/REDIS/container/app.py",
    "APPS/REDIS/container/Dockerfile",
    "APPS/REDIS/cloud-run.yaml",
    "APPS/REDIS/docs/internal/redis_internal.md",
    "PLATFORM/PROVIDERS/GCP/DEV/README.md"
]
updated_by = "Codex"
version = "1.0"
+++

> **Parent**: [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/docs/internal/README.md)<br>
> **Related**: [`app.py`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/container/app.py) | [`Dockerfile`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/container/Dockerfile) | [`cloud-run.yaml`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/cloud-run.yaml)<br>
> **Visibility**: internal<br>
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Explains graceful shutdown and gives an implementation-ready design for the Redis heartbeat client and its Cloud Run deployment.
- Questions Answered: What is graceful shutdown, why is it needed here, what currently prevents deployment, and how should signals, Redis cleanup, and verification work?
- When to Retrieve: Changing APPS/REDIS/container/app.py, its Dockerfile, local Compose behavior, or Cloud Run configuration.
- When NOT to Retrieve: Changing Redis key schemas, TTL policies, or non-runtime documentation.
-->

# Graceful Shutdown for the Redis Client and Cloud Run

## Short answer

Yes. 
Graceful shutdown is both feasible and useful for this project. The current Python program in `APPS/REDIS/container/app.py` runs indefinitely after it connects to Redis. It can be changed to react to a stop request, stop its heartbeat promptly, close its Redis client, log a final structured message, and exit with success before Docker or Cloud Run forcibly ends the process.

This document is a design and implementation guide. It deliberately does **not** modify the running client yet. That keeps the design reviewable and avoids choosing the wrong Cloud Run workload type by accident.


## What "graceful shutdown" means

Every operating system process can be told to stop. On Linux, that request is commonly delivered as a **signal**. The important signals here are:

| Signal | Meaning in this design | Can application code handle it? |
| :--- | :--- | :---: |
| `SIGTERM` | Normal request to finish cleanup and exit. Docker Compose and Cloud Run use this during ordinary termination. | Yes |
| `SIGINT` | Interactive interruption, normally sent by pressing `Ctrl+C` locally. | Yes |
| `SIGKILL` | Immediate forced termination after the allowed time is exhausted. | No |

Without graceful shutdown, the process may stop while it still has an open Redis socket, buffered telemetry, a partial message acknowledgement, or an in-memory unit of work. With graceful shutdown, it receives `SIGTERM`, performs only bounded cleanup, and exits itself. This does not make every failure recoverable: memory-limit failures, host failures, and `SIGKILL` can still be abrupt. The application must therefore remain correct even if cleanup never runs.

For this Redis heartbeat client, the cleanup is deliberately small:

1. Record that termination began.
2. Tell the heartbeat loop not to begin another iteration.
3. Close the Redis client and its connection pool.
4. Flush telemetry only when doing so has a strict timeout.
5. Record successful completion and exit with code `0`.

It must **not** use shutdown to write business-critical booking data to Redis. In this project Redis is a cache and transient-state layer, not the source of truth. Any durable booking or message-processing result must already have been committed to its authoritative system before shutdown begins.

## Why it matters in this repository

The current client has an infinite `while True` loop and calls `time.sleep(10)`. It does not register a signal handler, does not close `r`, and does not log a normal termination path. Locally, `docker compose down` normally sends `SIGTERM`; Cloud Run sends the same signal when it shuts down an instance.

The Dockerfile already uses JSON-array `CMD` form:

```dockerfile
CMD ["/opt/venv/bin/python", "/app/app.py"]
```

This is a good foundation because Python is PID 1, the process that receives the container signal directly. Do not change it to shell form such as `CMD python /app/app.py`; a shell can prevent the child Python process from receiving the signal reliably.

## Important: the current Cloud Run template cannot start as a service

`APPS/REDIS/cloud-run.yaml` defines a **Cloud Run service** and declares container port `8080`. A Cloud Run service requires its ingress container to listen for HTTP requests on `0.0.0.0` and the injected `PORT` value. The current client only opens an outgoing TCP connection to Redis. It exposes no HTTP server, so it cannot satisfy the service startup contract.

This is separate from graceful shutdown, but it must be resolved before the YAML can be deployed successfully. Use the workload type that matches the work:

| Intended behavior | Correct Cloud Run choice | What the application must do |
| :--- | :--- | :--- |
| Provide an HTTP endpoint that checks Redis or serves cache-backed API requests | **Service** | Start an HTTP server on `0.0.0.0:$PORT`; expose health endpoints; drain and clean up on termination. |
| Run one Redis connectivity smoke test and exit | **Job** | Connect, run `PING`, report the result, close the client, and exit. No infinite loop. |
| Continuously pull tasks from Kafka or another queue | **Worker pool** | Poll work, stop fetching new work on `SIGTERM`, finish bounded in-flight work, then close resources. |

The current loop is only a heartbeat smoke test, not a user-facing HTTP API or a useful continuous worker. The simplest operational design is a **Cloud Run job** that runs `PING` and exits, scheduled separately if periodic validation is required. If the near-term goal is to learn request handling, turn it into a small HTTP service instead. Do not deploy the existing loop as a Cloud Run service merely to keep a Redis connection alive.

## Cloud Run shutdown behavior and the time budget

Cloud Run sends `SIGTERM` before shutting down a service or worker instance. The container has a 10-second grace period; after that Cloud Run sends `SIGKILL`, which no application can catch. The platform may normally route new requests away from an instance that is being shut down, but exceptional shutdowns can still overlap with in-flight work.

That means cleanup needs a **smaller application budget**, such as 5 seconds. The remaining time gives process scheduling, logging, and the operating system room to complete. Treat 10 seconds as the absolute ceiling, not as a target.

Recommended timing policy:

| Item | Recommended value | Reason |
| :--- | :---: | :--- |
| Maximum normal cleanup | 5 seconds | Leaves margin within Cloud Run's 10-second platform window. |
| Heartbeat wait interval | 1 second or less | Lets the main loop notice shutdown promptly. |
| Redis socket connect/read timeout | 1-2 seconds | Prevents cleanup or normal work from hanging on an unavailable dependency. |
| Shutdown attempts | 1 | Retrying long cleanup is less valuable than exiting predictably. |
| Separate forced-exit watchdog | No, while cleanup stays bounded | The example has no unbounded cleanup work; add a deadline-aware watchdog before adding any slow cleanup. |

## Recommended implementation for the current heartbeat client

The following example is a direct replacement shape for `container/app.py`. It uses only the Python standard library plus the existing `redis` dependency. It is intentionally simple so the signal lifecycle is visible.

```python
import logging
import os
import signal
import threading
import time

import redis


LOG = logging.getLogger(__name__)
STOP_REQUESTED = threading.Event()
SHUTDOWN_STARTED = threading.Event()


def request_shutdown(signum, _frame):
    """Make shutdown idempotent; signal handlers should return quickly."""
    if SHUTDOWN_STARTED.is_set():
        LOG.warning("shutdown_signal_repeated signal=%s", signum)
        return

    SHUTDOWN_STARTED.set()
    LOG.info("shutdown_started signal=%s", signum)
    STOP_REQUESTED.set()


def build_redis_client():
    return redis.Redis(
        host=os.getenv("REDIS_HOST", "localhost"),
        port=int(os.getenv("REDIS_PORT", "6379")),
        password=os.getenv("REDIS_PASSWORD"),
        decode_responses=True,
        socket_connect_timeout=2,
        socket_timeout=2,
    )


def main():
    logging.basicConfig(
        level=os.getenv("LOG_LEVEL", "INFO"),
        format="%(asctime)s %(levelname)s %(message)s",
    )
    signal.signal(signal.SIGTERM, request_shutdown)
    signal.signal(signal.SIGINT, request_shutdown)

    client = None
    try:
        client = build_redis_client()
        client.ping()
        LOG.info("redis_connected")

        # Event.wait() returns immediately when SIGTERM or Ctrl+C sets the event.
        while not STOP_REQUESTED.wait(timeout=1):
            LOG.info("heartbeat")
    except redis.RedisError:
        LOG.exception("redis_client_failed")
        return 1
    finally:
        if client is not None:
            try:
                client.close()
                LOG.info("redis_client_closed")
            except redis.RedisError:
                LOG.exception("redis_client_close_failed")

    LOG.info("shutdown_complete")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
```

### Why each part exists

- `threading.Event` is a shared, thread-safe stop flag. It is safer than trying to do network cleanup inside the signal handler itself.
- `request_shutdown` is **idempotent**: a repeated `SIGTERM` changes nothing after the first one. This avoids duplicate cleanup and confusing logs.
- The handler only sets flags and logs. A signal handler should return quickly; closing sockets or exporting telemetry inside it can deadlock or exceed the deadline.
- `Event.wait(timeout=1)` replaces `time.sleep(10)`. It wakes immediately after the stop flag is set, while the timeout preserves the heartbeat cadence.
- Redis timeouts keep both normal operations and cleanup bounded when Memorystore is unavailable.
- `finally` runs for a normal stop, an interactive `Ctrl+C`, and most handled errors. `client.close()` returns pooled connections instead of leaving them to disappear at process termination.
- `raise SystemExit(main())` makes the intended exit code explicit: `0` for a planned shutdown and `1` for a Redis failure.

The example does not add a second watchdog timer because every operation it performs is already bounded. If future cleanup adds telemetry, database transactions, or message acknowledgements, run them through a deadline-aware helper and stop attempting cleanup once 5 seconds have elapsed.

## If this becomes an HTTP Cloud Run service

An HTTP service has a second responsibility: it must stop accepting new work while allowing the server framework to close its listener and complete safe cleanup. The practical design is:

1. Bind Uvicorn, Gunicorn, or another HTTP server to `0.0.0.0` and `PORT`.
2. Add `/healthz` for liveness and `/readyz` for readiness. While draining, `/readyz` must return an unavailable response.
3. Keep the Redis client in an application lifecycle hook rather than creating one per request.
4. On shutdown, mark the application as draining, stop accepting new work through the server framework, close Redis, flush bounded telemetry, and exit.
5. Make every business operation idempotent. A request may be retried by a caller after a connection interruption.

For a FastAPI application, prefer FastAPI's lifespan hook for opening and closing the Redis client. Let the HTTP server own request draining and its `SIGTERM` handling; application shutdown code should close dependencies and must not call `os._exit()` or `kill` itself. The Cloud Run container command would then start the server using the injected port, for example:

```dockerfile
CMD ["/opt/venv/bin/uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
```

In practice, use a small launcher or Uvicorn configuration that reads `PORT` instead of hard-coding `8080`. This example only illustrates the required server shape. The current `requirements.txt` does not include FastAPI or Uvicorn, so this is a future service conversion, not a drop-in change.

## If this becomes a Cloud Run job

A job should not contain an endless heartbeat loop. Its normal lifecycle is:

```text
start -> create Redis client -> PING -> log success/failure -> close client -> exit
```

That is already naturally graceful because the `finally` block closes the client. Still install `SIGTERM` handling if the job later gains a longer operation, such as validating a sample of cache keys or warming non-critical cache entries. Never make cache warming a prerequisite for a booking workflow; cache contents must be reconstructable.

## Future message consumers: a stricter shutdown sequence

The client currently processes no business messages. A later Pub/Sub or Kafka consumer must not merely close its connection on `SIGTERM`, because it can lose track of in-flight work. Use this sequence instead:

```text
SIGTERM received
  -> set draining=true
  -> stop polling for new messages
  -> wait only until the local cleanup deadline for in-flight handlers
  -> commit/acknowledge only work that was durably completed
  -> leave unfinished messages unacknowledged for redelivery
  -> close consumer, Redis, database, and telemetry clients
  -> log shutdown_complete and exit 0
```

The safety rule is important: acknowledge a message **after** its durable, idempotent result is committed, never before. Redis cache writes alone do not prove business completion. For example, a quote-generation worker should persist its authoritative quote status before acknowledging `event.quote.generated`; a cache refresh may be repeated safely.

## Local verification plan

Run these checks after implementation. They validate behavior instead of only confirming that the process starts.

### 1. Confirm a normal local shutdown

```bash
cd APPS/REDIS
docker compose up --build
```

In a second terminal, stop the stack with `Ctrl+C` or:

```bash
docker compose down --timeout 10
```

Expected client log order:

```text
redis_connected
shutdown_started signal=15
redis_client_closed
shutdown_complete
```

The app container should exit with status `0`; it should not need to be killed after the timeout. The Redis container has its own lifecycle and is not validated by the Python client's log sequence.

### 2. Prove the process handles `SIGTERM` directly

Start the Compose stack first so the client can reach the `redis` service:

```bash
cd APPS/REDIS
docker compose up --build -d
```

Then send `SIGTERM` to only the application container and inspect its exit status:

```bash
docker compose stop --timeout 10 app
docker compose ps app
docker compose logs app
```

The application should be stopped with exit code `0`, and its logs should contain the expected shutdown sequence. `docker compose stop` is used here instead of killing a separately launched container so the test uses the actual Compose network and Redis hostname from this repository.

### 3. Test the failure path

Point `REDIS_HOST` to an unreachable address. The client should log `redis_client_failed`, exit non-zero promptly because of the socket timeout, and never hang indefinitely. This is important because an unavailable dependency is more common than a clean shutdown in early development.

### 4. Test Cloud Run only after choosing the resource type

For an HTTP service, confirm all of the following before deployment:

- The server listens on `0.0.0.0:$PORT`.
- `/healthz` returns success after startup.
- `/readyz` becomes unavailable while draining.
- A deployment revision change produces the `shutdown_started` and `shutdown_complete` logs for the old revision.

For a job, confirm that the run exits successfully after one `PING`, and that a cancelled long-running test records a `SIGTERM` shutdown. Check Cloud Logging for the lifecycle messages, not just the Cloud Run console's success state.

## Acceptance criteria

The implementation is complete when all of these are true:

- `SIGTERM` and local `Ctrl+C` are handled without a Python traceback.
- The process stops its loop within one second of the signal under normal conditions.
- Redis operations have finite timeouts and the client is closed once.
- Logs distinguish `shutdown_started`, `redis_client_closed`, and `shutdown_complete`.
- Normal termination exits `0`; a Redis connectivity failure exits non-zero.
- Docker uses exec/JSON command form so the application receives signals as PID 1.
- The Cloud Run configuration matches the application shape: HTTP service, finite job, or worker pool.
- No business-critical state relies on cleanup running or on Redis surviving the shutdown.

## Implementation order

1. Replace the infinite loop with the signal-aware client shown above and add a focused automated test for the stop event.
2. Run the local signal test and capture the expected logs.
3. Decide whether this component is a Cloud Run job or an HTTP service. Update `cloud-run.yaml` only after that decision.
4. For an HTTP service, add its framework, lifecycle hooks, health endpoints, and `$PORT` binding.
5. Add Cloud Logging queries and an alert for repeated non-zero exits or shutdowns that lack `shutdown_complete`.
6. Apply the consumer-specific draining rules before adding Pub/Sub or Kafka message handling.

## Authoritative platform references

- [Cloud Run execution environments: graceful shutdowns](https://cloud.google.com/run/docs/configuring/execution-environments#graceful_shutdowns) documents the `SIGTERM` signal and the 10-second shutdown period.
- [Cloud Run container runtime contract](https://cloud.google.com/run/docs/container-contract#shutdown) documents request handling during shutdown and the final `SIGKILL`.
- [Cloud Run service container requirements](https://cloud.google.com/run/docs/container-contract#port) documents the `0.0.0.0:$PORT` listener requirement.
