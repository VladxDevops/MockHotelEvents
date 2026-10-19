+++
title = "Project Transcripts"
domain = "project-ledger"
topics = ["changelog", "project-ledger", "hotel-events"]
difficulty = "intermediate"
progressive_tier = "Tier 2"
parent = "AI_MANIFEST.toml"
children = []
related = [
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "APPS/SALESFORCE/README.md",
    "APPS/REDIS/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`AI_MANIFEST.toml`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AI_MANIFEST.toml)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/SALESFORCE/README.md)  
> **Progressive Tier**: Tier 2

<!-- AI RETRIEVAL HINTS:
- Purpose: Provides internal project knowledge for the Hotel Events wedding inquiry architecture, interview readiness, and implementation planning.
- Questions Answered: What internal knowledge should be loaded before deeper component work?
- When to Retrieve: Working on project ledger context for the Hotel Events wedding inquiry platform.
- When NOT to Retrieve: Working on unrelated generated assets, dependency lockfiles, or implementation code that does not need documentation context.
-->
# Project Transcripts

Short project notes and major decisions for the Hotel Events Planning learning repository.

## 2026-10-18 — Root README is a map, not a second spec
- `README.MD` introduces the mock wedding inquiry, the stack, and the trust boundaries, then links to `spects.md`, the architecture docs, and component READMEs.
- Component detail stays in those documents. The landing page records that Apigee Terraform, Salesforce notes, and a Redis sketch exist, and that MuleSoft, Kafka, and the full booking path are still specified rather than complete.
- AI agent support is mentioned only as "agents are clients of the same APIs," with the catalog left in `ai-agent-connections.md`.

## 2026-10-18 — AI agent connections are clients, not a new system of record
- Planning decision: if sales people use one or more AI agents, those agents call the existing Apigee, Salesforce, and event contracts.
- Connections are enablement switches per role and environment: northbound API tools, MCP over those tools, CRM user delegation, event subscriptions, channel drafts, knowledge read, cache read through an API, analytics views, document drafts, approval gates, observability read, and agent handoff events.
- Commit actions for quote send, booking, price override, cancellation, and guest notification require a human approval id.
- Redis stays a cache. Engineering agents that edit the repo do not receive business write tools.
- Canonical plan: `AGENTS/PLANNING/PRODUCT-ROADMAP/ai-agent-connections.md`.

## 2026-09-11 — Apigee foundation for the hotel events platform
- Created the first Terraform implementation for Apigee as a managed API gateway layer for the hotel events architecture.
- Built the module under `PLATFORM/PROVIDERS/GCP/TERRAFORM/MODULES/APIgee/` and scoped it to the lowest-hanging-fruit pattern: Apigee organization, runtime instance, environment, and environment group.
- Added the root Terraform entrypoint under `PLATFORM/PROVIDERS/GCP/TERRAFORM/` so the project can deploy the Apigee layer from a single configuration set.
- Added placeholder values in `PLATFORM/PROVIDERS/GCP/DEV/dev.tfvars` and root `terraform.tfvars` to support a dev environment model.
- Renamed the project variable from `project_id` to `compute_project_id` to make the provider input more explicit and avoid confusion with the GCP resource project ID used elsewhere.
- Kept the Apigee peering block at `10.0.0.0/22` as a standard reserved service CIDR placeholder; this is a networking requirement for the managed runtime, not a general application subnet.
- Validated the configuration with Terraform formatting and `terraform validate` successfully.

### Key decisions
- Apigee is being used as the API management and gateway layer rather than a full replacement for MuleSoft in this architecture.
- The Terraform code focuses on the platform foundation only; the actual proxy definitions are intentionally left for CI/CD or Apigee-specific deployment tooling.
- This approach keeps the project realistic for a GCP-focused role while still aligning with the hotel events wedding inquiry scenario.

## 2026-09-11 — Apigee X (Evaluation) end-to-end infrastructure, ingress routing, and automated deployment pipeline
- Implemented the complete end-to-end Terraform deployment for Apigee X (Evaluation) in `PLATFORM/PROVIDERS/GCP/TERRAFORM/`:
  - **Dynamic Project Control**: Supported conditional project provisioning via `google_project` (when `var.create_project = true`) or binding directly into an existing GCP project with billing association.
  - **Service Enablement & Propagation**: Automated enablement of `cloudresourcemanager.googleapis.com`, `compute.googleapis.com`, `servicenetworking.googleapis.com`, and `apigee.googleapis.com` with a 60-second `time_sleep` buffer to avoid Google control-plane eventual consistency race conditions.
  - **Network Topology**: Provisioned custom VPC `apigee-vpc`, regional compute subnet `apigee-subnet` (`10.100.0.0/24`) with Private Google Access, and a regional Envoy proxy-only subnet `apigee-proxy-only-subnet` (`10.100.1.0/24`, `purpose = "REGIONAL_MANAGED_PROXY"`, `role = "ACTIVE"`).
  - **Private Service Access (PSA)**: Configured internal `/22` IP allocation (`google_compute_global_address`) peered via `google_service_networking_connection` with a 30-second settling delay.
  - **Apigee X Evaluation Core**: Provisioned `google_apigee_organization` (`billing_type = "EVALUATION"`, `runtime_type = "CLOUD"`, CMEK-free), `google_apigee_instance` in `us-central1` attached to the `/22` peering range, `google_apigee_environment` (`dev`), and `google_apigee_envgroup` (`dev-env-group`).
  - **Northbound Ingress Routing**: Created a Private Service Connect (PSC) Network Endpoint Group (`google_compute_region_network_endpoint_group`, type `PRIVATE_SERVICE_CONNECT`) pointing to Apigee's `service_attachment`, wired to a Global External Application Load Balancer (`EXTERNAL_MANAGED`).
  - **Dual Frontend Access**: Allocated static global IP with Port 80 (HTTP) forwarding rule for zero-config CLI smoke tests and Port 443 (HTTPS) forwarding rule using a self-signed TLS certificate (`tls_self_signed_cert`) matching environment group hostnames.
- Created sample mock API proxy bundle in `PLATFORM/PROVIDERS/GCP/TERRAFORM/sample-proxy/mock-hotel-events/` and `.zip` archive implementing:
  - `/v1/healthz`: Health check endpoint returning HTTP 200 and JSON status via `AM-HealthCheckResponse`.
  - `/v1/events/inquiries`: Mock wedding inquiry endpoint returning HTTP 200 and JSON payload via `AM-InquiryResponse`.
- Created deployment automation: Built `PLATFORM/PROVIDERS/GCP/TERRAFORM/deploy-proxy.sh` script to package, import, and deploy proxy revisions via Apigee Management REST APIs with `gcloud` access tokens, integrated with Terraform via `null_resource.sample_proxy_deployment`.
- Developed automated smoke-testing CLI tool `PLATFORM/PROVIDERS/GCP/TERRAFORM/test-apigee.sh` with retry loops, HTTP/HTTPS and inquiry endpoint validation, and automated Terraform output resolution.
- Updated `.gitignore` to strictly exclude sensitive credentials and state files (`*.tfvars`, `*.tfvars.json`, `*.tfstate`, `.terraform/`).
- Documented architecture and deployment commands in `PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md`, `APPS/APIgee/apigee-architecture-summary.md`, and `PLATFORM/PROVIDERS/GCP/TERRAFORM/output.md`.
- Successfully validated configuration with `terraform fmt`, `terraform validate`, and verified execution plans for both existing project (30 resources) and dynamic new project (31 resources) modes.

### Key decisions
- **Apigee X Evaluation Tier**: Selected `billing_type = "EVALUATION"` to avoid Cloud KMS CMEK billing and setup requirements while retaining full enterprise Apigee X API gateway capabilities for development and validation.
- **Northbound Ingress via PSC NEG + External ALB**: Adopted Google Cloud's recommended production-ready ingress pattern for Apigee X, routing external traffic through a global external HTTPS/HTTP load balancer and Private Service Connect NEG into the tenant project.
- **Dual HTTP & HTTPS Ingress**: Provided Port 80 alongside HTTPS to allow immediate smoke testing without requiring pre-configured DNS records or public CA certificates during initial sandbox spin-up.
- **Automated Proxy Deployment Lifecycle**: Added `null_resource.sample_proxy_deployment` and `deploy-proxy.sh` to bridge the gap between infrastructure provisioning and immediate functional verification of the Hotel Events API proxies.
- **Platform Role**: Established Apigee X as the perimeter Northbound API gateway providing traffic management, rate limiting, and API security protecting downstream MuleSoft integrations, Kafka/PubSub streaming, and Redis caching.

## 2026-09-08 — Redis client graceful shutdown design
- Documented a signal-aware shutdown design for the Redis heartbeat client in `APPS/REDIS/docs/internal/graceful-shutdown.md`.
- Identified that the current `cloud-run.yaml` declares an HTTP Cloud Run service while `container/app.py` does not listen on `PORT`; deployment must choose a Cloud Run job, a worker pool, or a real HTTP service before it can start correctly.
- Established a bounded cleanup sequence: react to `SIGTERM`, stop new work, close Redis, flush only time-bounded telemetry, log completion, and exit before Cloud Run's forced termination window.

### Key decisions:
- Redis remains cache and transient state; graceful shutdown must never be required to preserve authoritative booking data.
- The existing JSON-array Docker `CMD` form is retained because it lets the Python process receive container signals directly.
- This pass is documentation-only; no runtime behavior or deployment manifest was changed.

## 2026-09-08 — Terragrunt multi-environment infrastructure framework
- Documented Terragrunt installation and usage patterns for multi-environment GCP deployment
- Created comprehensive folder structure documentation (`folder-structure.md`) showing:
  - `live/` folder pattern for DEV, TEST, STAGING, PROD environments
  - `modules/` folder for reusable Terraform components
  - Root `terragrunt.hcl` for shared configuration inheritance
  - Environment-specific `terragrunt.hcl` files for overrides and component deployment
- Created agent guides for:
  - `PLATFORM/PROVIDERS/GCP/` (infrastructure index)
  - `PLATFORM/PROVIDERS/GCP/DEV/` (DEV environment context and governance)
  - `PLATFORM/PROVIDERS/` (multi-cloud provider framework)
- Updated `DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md` to include Terragrunt and multi-environment separation concepts
- Updated changelog and transcripts to reflect infrastructure documentation milestone

### Key decisions:
- Documentation-only specification for folder structure (no IaC code generated yet)
- DEV environment is the initial deployment target for proof of concept
- Terragrunt configuration inheritance pattern selected for consistency and scalability
- Four-environment model (DEV → TEST → STAGING → PROD) with progressive access controls

## 2026-09-04 — Repository-wide Progressive Disclosure normalization
- Applied the local `AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/` guidance to Markdown documentation across the repository.
- Standardized non-executable documentation with TOML front matter, file-based breadcrumbs, progressive tier labels, and AI retrieval hints.
- Created lightweight README indexes for documentation folders with Markdown content so agents can load local context progressively.
- Added `APPS/KAFKA/README.md` as the current Kafka event-streaming documentation entry point and aligned manifest references to the actual app/platform layout.
- Preserved executable `AGENTS/SKILLS/**/SKILL.md` YAML metadata to avoid breaking skill discovery.
- No files were moved, deleted, split, or merged during this pass.

## 2026-09-03 — Progressive Disclosure & Context Engineering System
- Brought and adapted the Progressive Disclosure skill from the Bank project to `AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/`.
- Adapted the architecture domain from banking/zero-trust to the Hotel Events wedding inquiry journey (Salesforce -> MuleSoft -> Kafka/PubSub -> Redis -> GCP/Terraform -> OpenTelemetry).
- Structured the repository knowledge into 4 Progressive Disclosure Tiers to prevent LLM context exhaustion.
- Published companion guides for the 3-phase lifecycle: Phase 1 (Analysis), Phase 2 (Implementation), and Phase 3 (AI Knowledge Guardian).
- Established `AI_MANIFEST.toml` as the canonical knowledge base control plane with health scoring and retrieval parameters.
- Standardized TOML front matter, breadcrumbs, and AI retrieval hints for all internal documentation.

## 2026-08-27 — Project direction
- Applied the local `AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/` guidance to Markdown documentation across the repository.
- Standardized non-executable documentation with TOML front matter, file-based breadcrumbs, progressive tier labels, and AI retrieval hints.
- Created lightweight README indexes for documentation folders with Markdown content so agents can load local context progressively.
- Added `APPS/KAFKA/README.md` as the current Kafka event-streaming documentation entry point and aligned manifest references to the actual app/platform layout.
- Preserved executable `AGENTS/SKILLS/**/SKILL.md` YAML metadata to avoid breaking skill discovery.
- No files were moved, deleted, split, or merged during this pass.

## 2026-09-03 — Progressive Disclosure & Context Engineering System
- Brought and adapted the Progressive Disclosure skill from the Bank project to `AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/`.
- Adapted the architecture domain from banking/zero-trust to the Hotel Events wedding inquiry journey (Salesforce -> MuleSoft -> Kafka/PubSub -> Redis -> GCP/Terraform -> OpenTelemetry).
- Structured the repository knowledge into 4 Progressive Disclosure Tiers to prevent LLM context exhaustion.
- Published companion guides for the 3-phase lifecycle: Phase 1 (Analysis), Phase 2 (Implementation), and Phase 3 (AI Knowledge Guardian).
- Established `AI_MANIFEST.toml` as the canonical knowledge base control plane with health scoring and retrieval parameters.
- Standardized TOML front matter, breadcrumbs, and AI retrieval hints for all internal documentation.

## 2026-08-27 — Project direction
- Established the repository as a mock hospitality events scenario focused on a wedding inquiry.
- Confirmed the learning objective: understand how a sales workflow connects to integration, messaging, cloud, and observability patterns.
- Chose a realistic enterprise tool chain: Salesforce, Mulesoft, Pub/Sub, Kafka, Terraform, GCP, OpenTelemetry, and Redis/Memorystore.
- Documented that the project is for learning by doing, not production deployment.

## 2026-08-27 — Documentation approach
- Kept the main project summary short and reference-driven.
- Moved detailed content into focused docs such as specs, architecture overview, and Salesforce planning notes.
- Treated the customer landing page as a conceptual reference only.

## Related docs
- `Agents.md` — main project entry point
- `DOCUMENTATION/INTERNAL/spects.md` — central summary
- `DOCUMENTATION/INTERNAL/architecture-overview.md` — high-level architecture
- `SUBPROJECTS/SALESFORCE/README.md` — CRM workflow and process context
