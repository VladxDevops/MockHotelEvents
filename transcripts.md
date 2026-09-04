# Project Transcripts

Short project notes and major decisions for the Hotel Events Planning learning repository.

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
