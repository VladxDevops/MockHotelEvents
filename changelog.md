+++
title = "Changelog"
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
# Changelog

This project is intentionally a learning-by-doing repository for mock enterprise architecture and integration work.

## [2026-09-11]
### Added
- Added an Apigee-focused Terraform foundation under `PLATFORM/PROVIDERS/GCP/TERRAFORM/MODULES/APIgee/` for the hotel events platform.
- Created the lowest-hanging-fruit Apigee module consisting of:
  - `main.tf` — organization, runtime instance, environment, and environment group resources
  - `variables.tf` — module-level inputs for a GCP project, region, runtime configuration, and DNS hostnames
  - `outputs.tf` — standardized outputs for core Apigee objects
- Created the root GCP Terraform deployment layer at `PLATFORM/PROVIDERS/GCP/TERRAFORM/` to call the Apigee module from a single entrypoint.
- Added dev placeholder values in `PLATFORM/PROVIDERS/GCP/DEV/dev.tfvars` and root `terraform.tfvars` for the initial Apigee deployment.

### Updated
- Renamed the root project variable from `project_id` to `compute_project_id` to make the intent clearer for the compute project used by the Apigee deployment.
- Updated Apigee module references and provider configuration to use the renamed variable consistently.
- Kept the Apigee CIDR block at a realistic placeholder size for a managed Apigee runtime (`10.0.0.0/22`) while documenting it as a reserved peering range rather than application subnet capacity.

### Validation
- Ran Terraform formatting and validation successfully for the root GCP Terraform folder.
- Confirmed the configuration is valid and ready for a real project-specific `terraform plan` once actual GCP project IDs and networking values are finalized.

### Notes
- This pass is intentionally scoped to the lowest-hanging-fruit API management layer.
- The Apigee proxy bundle itself is still treated as a separate deployment concern from the Terraform-managed base runtime foundation.

### Added (Apigee X Evaluation Infrastructure & End-to-End Pipeline)
- Implemented end-to-end Apigee X (Evaluation) infrastructure on Google Cloud Platform via Terraform under `PLATFORM/PROVIDERS/GCP/TERRAFORM/`:
  - **Dynamic Project Lifecycle**: Added conditional GCP project provisioning (`google_project`) controlled by `var.create_project` or binding to an existing GCP project with billing account association.
  - **Service API Enablement**: Automated activation of `cloudresourcemanager.googleapis.com`, `compute.googleapis.com`, `servicenetworking.googleapis.com`, and `apigee.googleapis.com` with 60-second `time_sleep` propagation delay buffers to eliminate control-plane race conditions.
  - **Dedicated VPC & Subnets**:
    - Custom VPC `apigee-vpc` (`auto_create_subnetworks = false`).
    - Standard regional subnet `apigee-subnet` (`10.100.0.0/24`) with Private Google Access enabled.
    - Regional proxy-only subnet `apigee-proxy-only-subnet` (`10.100.1.0/24`, `purpose = "REGIONAL_MANAGED_PROXY"`, `role = "ACTIVE"`) required for Envoy-based external Application Load Balancers.
  - **Private Service Access (PSA)**:
    - Global internal IP range reservation (`google_compute_global_address`, `/22` prefix length) dedicated to Apigee runtime peering.
    - Service Networking peering connection (`google_service_networking_connection`) with 30-second settling delay.
  - **Apigee X Evaluation Core**:
    - Apigee Organization (`google_apigee_organization`) configured for `billing_type = "EVALUATION"`, `runtime_type = "CLOUD"`, and CMEK-free operation.
    - Apigee Instance (`google_apigee_instance`) in `us-central1` bound to the reserved `/22` peering address range.
    - Apigee Environment (`google_apigee_environment`, name `dev`) and Environment Group (`google_apigee_envgroup`, name `dev-env-group` with hostnames).
    - Explicit resource bindings via `google_apigee_envgroup_attachment` and `google_apigee_instance_attachment`.
  - **Northbound Ingress Routing (L7 External Load Balancer)**:
    - Private Service Connect (PSC) Network Endpoint Group (`google_compute_region_network_endpoint_group`, type `PRIVATE_SERVICE_CONNECT`) pointing to the Apigee instance `service_attachment`.
    - Global External Application Load Balancer (`EXTERNAL_MANAGED`) backend service.
    - Static external IP address reservation (`google_compute_global_address`).
    - Dual frontend forwarding rules: Port 80 (HTTP) for immediate DNS/cert-free testing and Port 443 (HTTPS) with self-signed TLS certificate (`tls_self_signed_cert`) matching environment group hostnames.
- **Sample API Proxy Bundle & Automated Deployment Hook**:
  - Created complete mock API proxy bundle in `PLATFORM/PROVIDERS/GCP/TERRAFORM/sample-proxy/mock-hotel-events/` (and `.zip`) featuring:
    - `/v1/healthz`: Health check endpoint returning `200 OK` JSON via `AM-HealthCheckResponse` policy.
    - `/v1/events/inquiries`: Mock wedding inquiry endpoint returning `200 OK` JSON via `AM-InquiryResponse` policy.
  - Created `deploy-proxy.sh`: Packaging, importing, and deployment script interacting directly with the GCP Apigee Management REST API using `gcloud` authentication tokens.
  - Integrated Terraform lifecycle hook via `null_resource.sample_proxy_deployment` with SHA256 file triggers and explicit resource dependencies.
- **Verification & Smoke-Testing Tooling**:
  - Created `test-apigee.sh`: Automated CLI test runner with exponential retry loops, status checks, CLI flag parsing (`--http`, `--https`, `--inquiry`, `--all`, `--ip`, `--host`), and automated Terraform output resolution.
- **Architecture Documentation & Deployment Assets**:
  - Added enterprise architecture guide `APPS/APIgee/apigee-architecture-summary.md` and module docs `PLATFORM/PROVIDERS/GCP/TERRAFORM/MODULES/APIgee/` (`architechture.md`, `apigee-architecture-summary.md`).
  - Added implementation summary and validation report in `PLATFORM/PROVIDERS/GCP/TERRAFORM/output.md`.
  - Added environment variable templates `dev.tfvars`, `dev.tfvars.example`, and root `terraform.tfvars`.

### Updated (Apigee X Deployment & Git Hygiene)
- Updated `PLATFORM/PROVIDERS/GCP/TERRAFORM/README.md` to document the Apigee X Evaluation architecture, network layout, and CLI deployment commands.
- Updated `.gitignore` to enforce strict exclusions for sensitive credentials and state files (`*.tfvars`, `*.tfvars.json`, `*.tfstate`, `*.tfstate.*`, `.terraform/`).
- Standardized variable naming and module outputs across `PLATFORM/PROVIDERS/GCP/TERRAFORM/` and `MODULES/APIgee/`.

### Validation (Apigee X End-to-End Pipeline)
- Ran `terraform fmt` across all Terraform files.
- Ran `terraform validate` successfully with zero configuration errors.
- Verified execution plans via `terraform plan`:
  - Existing project mode: 30 resources planned cleanly.
  - Dynamic project mode (`create_project = true`): 31 resources planned cleanly.
- Verified script executable permissions and CLI argument handling for `deploy-proxy.sh` and `test-apigee.sh`.

### Notes (Apigee X Architecture)
- Built using the Apigee X Evaluation license model to avoid mandatory CMEK/Cloud KMS overhead and enable cost-effective sandbox validation.
- Apigee acts as the Northbound API gateway and edge security/routing tier in the Hotel Events platform, protecting downstream MuleSoft integrations, Kafka/PubSub streaming, and Redis caching.

## [2026-09-08]
### Added
- Added `APPS/REDIS/docs/internal/graceful-shutdown.md`, an internal implementation guide for signal-aware Redis client shutdown and the Cloud Run workload decision.
- Created comprehensive Terragrunt multi-environment infrastructure documentation:
  - `PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md` — Terragrunt implementation guide with installation and CI/CD usage patterns
  - `PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md` — Exact folder layout and responsibility definitions for live, modules, and environment-specific configurations
  - `PLATFORM/PROVIDERS/GCP/README.md` — GCP infrastructure index and overview
  - `PLATFORM/PROVIDERS/GCP/DEV/README.md` — DEV environment context, characteristics, and deployment guidance
  - `PLATFORM/PROVIDERS/README.md` — Multi-cloud provider framework documentation
- Updated `DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md` to include Terragrunt as the infrastructure orchestration layer and add environment-aware architecture concepts

### Updated
- Architecture documentation now reflects DEV, TEST, STAGING, and PROD environment separation using Terragrunt
- Interview-friendly summary now includes Terragrunt and multi-environment context

### Notes
- Terragrunt documentation is documentation-only; no IaC code files have been generated yet
- DEV environment is the initial target for infrastructure implementation
- Folder structure supports GitOps delivery model using Git as source of truth

## [2026-09-04]
### Updated
- Applied Progressive Disclosure metadata, breadcrumbs, and AI retrieval hints across repository Markdown documentation while preserving existing technical content.
- Added lightweight directory README indexes for Markdown-bearing documentation folders to support tiered context loading.
- Added `APPS/KAFKA/README.md` as the Tier 3 Kafka documentation entry point.
- Updated `AI_MANIFEST.toml` to version `1.1.0` and recorded the repository-wide documentation normalization scope.

### Notes
- Executable skill manifests under `AGENTS/SKILLS/**/SKILL.md` keep their YAML front matter so Codex skill loading remains intact.
- Progressive Disclosure skill references were aligned to the current `APPS/...` and `PLATFORM/PROVIDERS/GCP/...` repository layout.
- No documentation files were moved, deleted, split, or merged.

## [2026-09-03]
### Added
- Adapted Progressive Disclosure Skill (`AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/`) from the Bank platform, customized specifically for the Hotel Events wedding inquiry architecture.
- Established 4-Tier Progressive Disclosure Model and context loading sequences across Salesforce, MuleSoft, Pub/Sub, Kafka, Redis, and GCP/Terraform.
- Created companion reference guides: Phase 1 (Analysis & Architecture), Phase 2 (Implementation & Safe Refactoring), Phase 3 (AI Knowledge Guardian), and Hotel Events Documentation Hierarchy.
- Created `AI_MANIFEST.toml` at the repository root as the canonical machine-readable knowledge base control plane.
- Added document header and AI retrieval hint templates in `examples/`.

### Updated
- Updated `Agents.md` with Progressive Disclosure Skill reference, Context Protocol, and documentation map links.

## [2026-08-27]
### Added
- Initial repository definition for a mock hotel events planning project.
- Root project guide describing the wedding inquiry scenario and target technology stack.
- Salesforce subproject planning docs and process references.
- Internal documentation for a non-implemented customer landing page concept.
- Internal planning docs for stories, specs, architecture, and interview-ready learning notes.

### Updated
- Reduced duplication across project docs and replaced repeated narrative with references to the relevant source documents.
- Clarified that this project is designed for learning and demonstration, not production deployment.

### Notes
- The project focuses on a wedding inquiry flow from lead capture to booking confirmation.
- Salesforce, Mulesoft, Pub/Sub, Kafka, Terraform, GCP, and Redis are used as a realistic but mock enterprise architecture set.
- The landing page is a conceptual reference only.
### Updated
- Applied Progressive Disclosure metadata, breadcrumbs, and AI retrieval hints across repository Markdown documentation while preserving existing technical content.
- Added lightweight directory README indexes for Markdown-bearing documentation folders to support tiered context loading.
- Added `APPS/KAFKA/README.md` as the Tier 3 Kafka documentation entry point.
- Updated `AI_MANIFEST.toml` to version `1.1.0` and recorded the repository-wide documentation normalization scope.

### Notes
- Executable skill manifests under `AGENTS/SKILLS/**/SKILL.md` keep their YAML front matter so Codex skill loading remains intact.
- Progressive Disclosure skill references were aligned to the current `APPS/...` and `PLATFORM/PROVIDERS/GCP/...` repository layout.
- No documentation files were moved, deleted, split, or merged.

## [2026-09-03]
### Added
- Adapted Progressive Disclosure Skill (`AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/`) from the Bank platform, customized specifically for the Hotel Events wedding inquiry architecture.
- Established 4-Tier Progressive Disclosure Model and context loading sequences across Salesforce, MuleSoft, Pub/Sub, Kafka, Redis, and GCP/Terraform.
- Created companion reference guides: Phase 1 (Analysis & Architecture), Phase 2 (Implementation & Safe Refactoring), Phase 3 (AI Knowledge Guardian), and Hotel Events Documentation Hierarchy.
- Created `AI_MANIFEST.toml` at the repository root as the canonical machine-readable knowledge base control plane.
- Added document header and AI retrieval hint templates in `examples/`.

### Updated
- Updated `Agents.md` with Progressive Disclosure Skill reference, Context Protocol, and documentation map links.

## [2026-08-27]
### Added
- Initial repository definition for a mock hotel events planning project.
- Root project guide describing the wedding inquiry scenario and target technology stack.
- Salesforce subproject planning docs and process references.
- Internal documentation for a non-implemented customer landing page concept.
- Internal planning docs for stories, specs, architecture, and interview-ready learning notes.

### Updated
- Reduced duplication across project docs and replaced repeated narrative with references to the relevant source documents.
- Clarified that this project is designed for learning and demonstration, not production deployment.

### Notes
- The project focuses on a wedding inquiry flow from lead capture to booking confirmation.
- Salesforce, Mulesoft, Pub/Sub, Kafka, Terraform, GCP, and Redis are used as a realistic but mock enterprise architecture set.
- The landing page is a conceptual reference only.
