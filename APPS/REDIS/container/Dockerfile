FROM python:3.11-slim AS builder
WORKDIR /build
COPY requirements.txt ./
RUN python -m venv /opt/venv && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

FROM python:3.11-slim AS runtime
WORKDIR /app

COPY --from=builder --chown=10001:10001 /opt/venv /opt/venv
COPY --chown=10001:10001 app.py /app/app.py

RUN groupadd -g 10001 appgroup && \
    useradd -r -u 10001 -g appgroup appuser

USER appuser
CMD ["/opt/venv/bin/python", "/app/app.py"]
