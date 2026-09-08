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
