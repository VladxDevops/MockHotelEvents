# Hotel Events Documentation Hierarchy & AI Loading Protocol

## Overview
This document establishes the authoritative precedence levels, conflict resolution rules, and AI context ingestion sequence for the **Hotel Events Planning** repository.

Lower-level documents inherit constraints from higher-level documents and can **never** override them.

---

## 1. Precedence Levels

```
+-------------------------------------------------------------------------------+
| LEVEL 1: Global Safety, Project Scope & Directives (AUTHORITATIVE)             |
| security.md | Agents.md | spects.md | AI_MANIFEST.toml                        |
+-------------------------------------------------------------------------------+
                                        |
                                        v
+-------------------------------------------------------------------------------+
| LEVEL 2: Platform Architecture, Event Taxonomy & Cloud Specs (OPERATIONAL)     |
| architecture.md | cloud-infrastructure-checklist.md | event-schema.md         |
+-------------------------------------------------------------------------------+
                                        |
                                        v
+-------------------------------------------------------------------------------+
| LEVEL 3: Subproject & Component Implementation (LOCALIZED)                     |
| SUBPROJECTS/ (Salesforce, MuleSoft, Kafka, Redis) | PLATFORM/ (Terraform, OTel)|
+-------------------------------------------------------------------------------+
                                        |
                                        v
+-------------------------------------------------------------------------------+
| LEVEL 4: Operational Drills, Practice Labs & Troubleshooting (TARGETED)       |
| TROUBLEMAKER/ | practice-lab.md | QandAs.md | TROUBLESHOOTING/                |
+-------------------------------------------------------------------------------+
```

---

### Level 1: Global Safety, Project Scope & Directives (Authoritative)
These files define non-negotiable boundaries, enterprise constraints, and repository operating principles:
- [`DOCUMENTATION/INTERNAL/security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md): The Prime Directive (Security > Privacy > Velocity). Least-privilege IAM, zero public unauthenticated ingress to internal services, secret sanitization.
- [`Agents.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/Agents.md): Canonical repository guide, tech stack definition, GitOps delivery model, and agent operating rules.
- [`DOCUMENTATION/INTERNAL/spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md): Ground-truth specification for the hotel wedding inquiry journey and core assumptions.
- [`AI_MANIFEST.toml`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AI_MANIFEST.toml): Machine-readable control plane and health status.

---

### Level 2: Platform Architecture & Cross-Cutting Specifications (Operational)
These files govern system topography, cross-service interactions, data contracts, and project memory:
- [`DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md): End-to-end integration topology and service boundaries.
- [`DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture-overview.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture-overview.md): High-level architectural summary and component map.
- [`DOCUMENTATION/INTERNAL/ARCHITECTURE/wedding-inquiry-event-schema.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/wedding-inquiry-event-schema.md): Authoritative Kafka and Pub/Sub message schemas.
- [`PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md): Infrastructure provisioning checklist across GCP services.
- [`DOCUMENTATION/INTERNAL/glossary.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/glossary.md): Project terminology, architectural terms, and domain models.
- [`changelog.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/changelog.md) & [`transcripts.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/transcripts.md): Chronological ledger of durable architectural decisions.

---

### Level 3: Subproject & Platform Implementation Guides (Localized)
These files detail individual component configurations, API contracts, schemas, and modules:
- **Salesforce Subproject:** [`APPS/SALESFORCE/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/SALESFORCE/README.md) (Lead qualification, custom fields, opportunities)
- **MuleSoft Subproject:** [`APPS/Mulesoft/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/Mulesoft/) (Experience, Process, and System API flows)
- **Kafka Subproject:** [`APPS/KAFKA/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/KAFKA/) (Topics, partition keys, Avro/JSON serialization)
- **Redis Subproject:** [`APPS/REDIS/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/) (Key formatting, caching TTL, cache invalidation)
- **Terraform Platform:** [`PLATFORM/PROVIDERS/GCP/TERRAFORM/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/) (IaC modules, environment vars, remote state)
- **Observability Platform:** [`PLATFORM/PROVIDERS/GCP/OBSERVABILITY/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/OBSERVABILITY/) (OpenTelemetry collector, traces, GCP metrics)

---

### Level 4: Operational Drills, Practice Labs & Troubleshooting (Targeted)
These files support interactive learning, interview rehearsals, and failure injection:
- [`AGENTS/SKILLS/TROUBLEMAKER/SKILL.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/TROUBLEMAKER/SKILL.md): Safe, controlled fault injection in lab environments.
- [`DOCUMENTATION/INTERNAL/practice-lab.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/practice-lab.md): Hands-on exercises and implementation challenges.
- [`DOCUMENTATION/INTERNAL/interview-cheat-sheet.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/interview-cheat-sheet.md): 2-minute architectural explanation cheat sheet.
- [`DOCUMENTATION/INTERNAL/Learning-Qs-As/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/Learning-Qs-As/): Architectural and operational interview Q&A bank.
- Root [`TROUBLESHOOTING/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/TROUBLESHOOTING/): Incident triage and diagnostic playbooks.

---

## 2. Conflict Resolution Rules

1. **Rule of Absolute Precedence:** If guidance in a Level 3 or Level 4 document contradicts a Level 1 or Level 2 document, the higher-level document is authoritative.
2. **Redis Boundary Rule:** If any subproject documentation implies Redis is a permanent database, it is strictly overridden by Level 1 [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md). Redis is strictly a cache and transient session store.
3. **Salesforce System-of-Record Rule:** Salesforce manages customer relations and sales opportunities, but operational room/venue inventory is verified via the integration layer and internal inventory services.
4. **Security & Ingress Enforcement:** If a local implementation suggests allowing unauthenticated public traffic (`allUsers`) to backend microservices or MuleSoft process APIs, it is strictly overridden by Level 1 [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md).
5. **No Secrets in Code:** No suggestion in Level 3 to hardcode secrets, API keys, or private service credentials is valid. All secrets must be injected via Secret Manager or environment variables.

---

## 3. AI Document Loading Sequence by Task

AI agents must ingest documentation strictly according to the task at hand to maximize token efficiency:

### A. Salesforce / CRM Lead Flow Task
1. Load Level 1: [`Agents.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/Agents.md#L44-L50) (Customer & sales flow section)
2. Load Level 1: [`DOCUMENTATION/INTERNAL/spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) (Wedding inquiry requirements)
3. Load Level 3: [`APPS/SALESFORCE/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/SALESFORCE/README.md) (Lead qualification fields)
*Do NOT load:* Terraform code, Kafka schemas, or Redis cache scripts.

### B. MuleSoft API & Integration Orchestration Task
1. Load Level 1: [`DOCUMENTATION/INTERNAL/spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md)
2. Load Level 2: [`DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md)
3. Load Level 3: [`APPS/Mulesoft/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/Mulesoft/) (API flows)
4. Contextual lookup: [`APPS/REDIS/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/REDIS/README.md) (if availability caching is involved)
*Do NOT load:* GCP IAM Terraform modules, Landing page mockups, or TROUBLEMAKER failure drills.

### C. Kafka / PubSub Event Contract Task
1. Load Level 2: [`DOCUMENTATION/INTERNAL/ARCHITECTURE/wedding-inquiry-event-schema.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/wedding-inquiry-event-schema.md)
2. Load Level 3: [`APPS/KAFKA/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/KAFKA/)
3. Check Level 2: [`transcripts.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/transcripts.md) (Verify past schema decisions)
*Do NOT load:* Salesforce UI layout docs, Terraform networking modules.

### D. Terraform Cloud Infrastructure Task
1. Load Level 1: [`Agents.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/Agents.md#L66-L71) & [`DOCUMENTATION/INTERNAL/security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md)
2. Load Level 2: [`PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md)
3. Load Level 3: Target module in [`PLATFORM/PROVIDERS/GCP/TERRAFORM/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/)
*Do NOT load:* Salesforce lead workflows, Interview Q&As, or Redis business payloads.

### E. Failure Injection & Troubleshooting Task
1. Load Level 1: [`DOCUMENTATION/INTERNAL/security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md)
2. Load Level 4: [`AGENTS/SKILLS/TROUBLEMAKER/SKILL.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/TROUBLEMAKER/SKILL.md)
3. Load Level 4: Relevant guide in [`TROUBLESHOOTING/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/TROUBLESHOOTING/)
*Do NOT load:* Entire architecture trees or marketing overviews.
