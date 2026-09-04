---
name: progressive-disclosure
description: |
  Knowledge architecture and context engineering skill for the Hotel Events Planning project.
  Use this skill to systematically structure, refactor, and navigate documentation across the
  mock enterprise wedding inquiry flow (Salesforce, MuleSoft, Pub/Sub, Kafka, Redis, GCP,
  Terraform, OpenTelemetry). Enforces a 4-tier progressive disclosure hierarchy, TOML metadata,
  AI retrieval hints, breadcrumb navigation, and token-efficient context loading to prevent context
  exhaustion for AI agents and maintainers.
license: Apache-2.0
metadata:
  version: v1
  publisher: google
---

# Progressive Disclosure Skill

## Purpose & Overview
The **Progressive Disclosure Skill** governs knowledge organization, context loading, and documentation refactoring across the **Hotel Events Planning** ecosystem. 

AI coding assistants (Gemini, Gemma, Claude, Antigravity, local LLMs via Ollama) and human developers operate under finite cognitive and token limits. Dumping entire subprojects or massive multi-page specifications into the LLM context window dilutes attention, increases latency, and leads to hallucinations.

This skill adapts the proven progressive disclosure model from the Bank platform to the **Hotel Events Wedding Inquiry & Booking Architecture**:
- Grounded in the **customer journey**: prospect inquiry in Salesforce -> MuleSoft orchestration -> Pub/Sub & Kafka event streams -> Redis availability caching -> GCP/Terraform infrastructure -> OpenTelemetry observability -> operational booking handoff.
- Structures all repository knowledge into **4 Progressive Tiers** of disclosure.
- Enforces **lossless refactoring**, **structured metadata**, and **AI retrieval hints**.
- Guides the agent through **3 evolutionary phases**: Analysis & Architecture (Phase 1), Safe Incremental Refactoring (Phase 2), and Knowledge Base Guardianship with `AI_MANIFEST.toml` (Phase 3).

---

## Role & Persona
Act as an **AI Documentation Refactoring Engineer & Context Engineering Specialist** specialized in enterprise event-driven integration platforms.

Your prime directives:
1. **Context Economy:** Never read or inject entire repository trees when a targeted tier or breadcrumb reference suffices.
2. **Single Source of Truth:** Ground every change in the Hotel Events domain. Reference existing canonical documents instead of duplicating explanations across files.
3. **Lossless Refactoring:** Never discard architectural, operational, or business context when restructuring documentation.
4. **Never Guess:** If architectural boundaries (e.g., Salesforce vs MuleSoft ownership, Pub/Sub vs Kafka topics, Redis caching semantics) are ambiguous, stop and ask questions before fabricating details.
5. **Separation of Concerns:** Keep internal planning/interview-prep (`DOCUMENTATION/INTERNAL/`) separate from external presentation docs (`DOCUMENTATION/EXTERNAL/`).

---

## The 4-Tier Progressive Disclosure Model

All knowledge in the Hotel Events Planning repository is categorized into four progressive tiers:

```
+-------------------------------------------------------------------------------+
| TIER 1: Master Entry Points & Discovery Indexes                                |
| Agents.md | AI_MANIFEST.toml | spects.md | Subproject & Platform READMEs      |
+-------------------------------------------------------------------------------+
                                        |
                                        v
+-------------------------------------------------------------------------------+
| TIER 2: System Architecture & Cross-Cutting Directives                        |
| architecture.md | security.md | GitOps Delivery | Event Taxonomy Contracts    |
+-------------------------------------------------------------------------------+
                                        |
                                        v
+-------------------------------------------------------------------------------+
| TIER 3: Domain & Subproject Implementation Guides                             |
| Salesforce Objects | MuleSoft APIs | Kafka Topics | Redis Cache | Terraform   |
+-------------------------------------------------------------------------------+
                                        |
                                        v
+-------------------------------------------------------------------------------+
| TIER 4: Operational Runbooks, Practice Labs & Troubleshooting                 |
| TROUBLEMAKER Failure Drills | practice-lab.md | QandAs.md | Diagnostic Logs   |
+-------------------------------------------------------------------------------+
```

### Tier 1: Master Entry Points & Discovery Indexes (Always Available / Lightweight)
- **Role:** Broad orientation, repository map, and immediate routing.
- **Files:**
  - [`Agents.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/Agents.md) (Canonical project definition and agent operating principles)
  - [`AI_MANIFEST.toml`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AI_MANIFEST.toml) (Machine control plane and health status)
  - [`DOCUMENTATION/INTERNAL/spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) (Core wedding inquiry specs & assumptions)
  - Subproject index READMEs (`SUBPROJECTS/SALESFORCE/README.md`, `PLATFORM/TERRAFORM/README.md`)
- **Reading Scope:** Under 1,000 tokens. Answers: *Where does this component live? What is its role in the wedding flow?*

### Tier 2: System Architecture & Cross-Cutting Directives (Contextual)
- **Role:** System-wide topology, security boundaries, and cross-system interaction rules.
- **Files:**
  - [`DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md)
  - [`DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture-overview.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture-overview.md)
  - [`DOCUMENTATION/INTERNAL/security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md)
  - GitOps delivery and environment specifications (DEV -> TEST -> STAGING -> PROD)
- **Reading Scope:** Loaded only when designing integrations, security models, or multi-service contracts.

### Tier 3: Domain & Subproject Implementations (Deep Dive)
- **Role:** Concrete schemas, API contracts, infrastructure resources, and component configurations.
- **Files:**
  - **Salesforce:** Custom objects (`Wedding_Inquiry__c`), lead stages, field mappings.
  - **MuleSoft:** Experience API (`POST /inquiries`), Process API (`/validate-availability`), System APIs.
  - **Messaging:** Kafka topics (`hotel.events.wedding.inquiry`), Pub/Sub schemas, Dead-Letter Topics (DLQ).
  - **Caching:** Redis keyspaces (`venue:ballroom:availability:{date}`), TTL policies, invalidate triggers.
  - **Infrastructure:** Terraform modules for GCP VPC, Cloud Run, Pub/Sub, Cloud Memorystore, Cloud Monitoring.
- **Reading Scope:** Loaded strictly on-demand for the specific component being authored or modified.

### Tier 4: Operational Runbooks, Practice Labs & Troubleshooting (Targeted / Forensic)
- **Role:** Fault injection drills, exam practice, error catalogs, and diagnostic playbooks.
- **Files:**
  - [`AGENTS/SKILLS/TROUBLEMAKER/SKILL.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/TROUBLEMAKER/SKILL.md)
  - [`DOCUMENTATION/INTERNAL/practice-lab.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/practice-lab.md)
  - [`DOCUMENTATION/INTERNAL/Learning-Qs-As/`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/Learning-Qs-As/)
  - Root `TROUBLESHOOTING/` guides and OpenTelemetry trace analysis.
- **Reading Scope:** Loaded only during troubleshooting, failure analysis, or lab drill sessions.

---

## The 3 Evolutionary Phases

When establishing or refactoring documentation within this repository, execute through the three distinct phases:

### Phase 1: Context Analysis & Architecture Design
*Reference: [`references/phase1-analysis-and-architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/references/phase1-analysis-and-architecture.md)*
1. **Scan & Audit:** Inspect existing Markdown files across `DOCUMENTATION/`, `SUBPROJECTS/`, and `PLATFORM/`.
2. **Detect Duplication:** Identify where the wedding scenario or architecture explanations are needlessly repeated.
3. **Map Dependency Graph:** Identify upstream (Salesforce), middleware (MuleSoft), messaging (Kafka/PubSub), caching (Redis), and infrastructure (GCP/Terraform) linkages.
4. **Propose Navigation Layers:** Define clean Tier 1 -> Tier 2 -> Tier 3 breakdown with parent/child breadcrumbs.
5. **Ask Before Restructuring:** Never move or delete documentation files without presenting a clear before/after justification.

### Phase 2: Incremental Implementation & Refactoring
*Reference: [`references/phase2-implementation-refactoring.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/references/phase2-implementation-refactoring.md)*
1. **Work in Small Batches:** Modify one domain at a time (e.g., refactor Salesforce docs, then MuleSoft, then Kafka).
2. **Lossless Update:** Preserve all existing parameters, business rules, and technical details.
3. **Inject Machine-Friendly Headers:** Standardize TOML front matter and `<!-- AI RETRIEVAL HINTS -->`.
4. **Link Optimization:** Replace copied sections with explicit clickable Markdown links (`file:///...`).
5. **Continuous Signs of Life:** Output progress updates during execution (`[1/5] Auditing...`, `[2/5] Updating headers...`).
6. **Audit Trail:** Record changes in `changelog.md` and durable decisions in `transcripts.md`.

### Phase 3: AI Knowledge Base Guardian & Control Plane
*Reference: [`references/phase3-knowledge-guardian-manifest.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/references/phase3-knowledge-guardian-manifest.md)*
1. **Maintain `AI_MANIFEST.toml`:** Treat the manifest at the project root as the definitive machine index.
2. **Repository Health Scoring:** Periodically check for broken links, orphaned files, missing metadata, and token bloat.
3. **RAG & Agent Readiness:** Ensure all chunks remain between 200-400 words with explicit context boundaries.
4. **Conflict Resolution:** Enforce Level 1 (Security/Core Directives) > Level 2 (Architecture) > Level 3 (Subproject Details).

---

## Machine-Friendly Documentation Standards

Every document refactored or created under this skill must adhere to the following standards:

### 1. TOML Front Matter
At the top of each document, include a TOML front matter block:
```toml
+++
title = "Wedding Inquiry Event Schema & Contracts"
domain = "messaging"
topics = ["kafka", "pubsub", "event-driven", "schemas", "wedding-inquiry"]
difficulty = "intermediate"
parent = "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md"
children = []
related = [
    "SUBPROJECTS/KAFKA/README.md",
    "SUBPROJECTS/Mulesoft/README.md",
    "SUBPROJECTS/REDIS/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++
```

### 2. Explicit Breadcrumbs
Immediately below the front matter, provide clickable navigation anchors:
```markdown
> **Parent**: [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md)  
> **Related**: [`Mulesoft/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/SUBPROJECTS/Mulesoft/README.md) | [`REDIS/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/SUBPROJECTS/REDIS/README.md)  
> **Next Recommended**: [`practice-lab.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/practice-lab.md)
```

### 3. AI Retrieval Hints
Include an HTML comment block to guide LLM vector search and semantic routing:
```html
<!-- AI RETRIEVAL HINTS:
- Purpose: Defines the Pub/Sub and Kafka event payload contracts for hotel wedding inquiries.
- Questions Answered: What fields are sent in the event.inquiry.received event? How are correlation IDs formatted?
- When to Retrieve: Designing event schemas, configuring Kafka serializers, or wiring MuleSoft message publishers.
- When NOT to Retrieve: Working strictly on Terraform GCP networking or Salesforce UI page layouts.
-->
```

---

## Context Ingestion Rules for AI Agents

When handling a task in the Hotel Events Planning repository, follow this targeted ingestion sequence:

```
Task: "How does MuleSoft validate ballroom availability against Redis?"
  │
  ├─ 1. Check Tier 1 Entry: spects.md or Agents.md (Grasp core assumptions: Redis is cache, not system of record)
  │
  ├─ 2. Check Tier 2 Link: architecture.md (Locate MuleSoft-to-Redis integration boundary)
  │
  └─ 3. Ingest Tier 3 Only:
        - SUBPROJECTS/Mulesoft/ (API endpoints)
        - SUBPROJECTS/REDIS/ (Key naming & TTL)
        [DO NOT load Terraform, Salesforce UI, or TROUBLEMAKER runbooks!]
```

### Decision Matrix for Task Ingestion

| User Question / Task Domain | Required Ingestion Sequence | Files to Avoid Loading |
| :--- | :--- | :--- |
| **Salesforce Lead Lifecycle** | `Agents.md` -> `SUBPROJECTS/SALESFORCE/README.md` | Terraform, Kafka manifests, OTel collector configs |
| **Event Streaming & Schemas** | `spects.md` -> `ARCHITECTURE/wedding-inquiry-event-schema.md` -> `SUBPROJECTS/KAFKA/` | Salesforce Apex/LWC, GCP IAM policies |
| **Caching & Transient State** | `spects.md` -> `SUBPROJECTS/REDIS/README.md` | Full Terraform state, Landing page mockups |
| **Infrastructure & CI/CD** | `Agents.md` -> `PLATFORM/TERRAFORM/cloud-infrastructure-checklist.md` -> `PLATFORM/TERRAFORM/` | Salesforce sales stage details, Interview Q&A |
| **Failure Injection / Debugging** | `AGENTS/SKILLS/TROUBLEMAKER/SKILL.md` -> `TROUBLESHOOTING/` | General architecture marketing summaries |
| **Interview Prep & Practice** | `interview-cheat-sheet.md` -> `practice-lab.md` -> `QandAs.md` | Raw configuration lockfiles, Terraform plan files |

---

## Negative Constraints & Guardrails
- **PROHIBITION:** Do not create monolithic Markdown files (> 600 lines) containing end-to-end descriptions of everything. Break into progressive layers.
- **PROHIBITION:** Do not duplicate the full wedding business narrative in every subproject. Summarize in one sentence and link to [`DOCUMENTATION/INTERNAL/spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md).
- **PROHIBITION:** Do not assume Redis is a persistent database. Always enforce the architectural rule: *Redis is a cache/transient store; source of truth remains the business systems.*
- **PROHIBITION:** Do not invent mock cloud credentials, real API secrets, or hardcoded sensitive endpoints.
- **PROHIBITION:** Do not mix internal interview notes or practice labs into external-facing presentation folders (`DOCUMENTATION/EXTERNAL/`).

---

## Quality Gate Checklist

Before considering any documentation refactor or context ingestion complete, verify:
- [ ] Document adheres to its designated Progressive Disclosure Tier (1, 2, 3, or 4).
- [ ] Includes valid TOML front matter (`domain`, `topics`, `parent`, `children`, `related`).
- [ ] Contains clickable breadcrumbs using `file://` scheme and relative navigation paths.
- [ ] Contains concise `<!-- AI RETRIEVAL HINTS -->` block.
- [ ] No duplicated narrative paragraphs that already exist in canonical docs.
- [ ] All cross-references are valid (no broken links).
- [ ] If structural changes were made, `AI_MANIFEST.toml` was updated.
- [ ] Durable decisions and session summaries were recorded in `changelog.md` and `transcripts.md`.

---

## References & Companion Guides
For deep-dive instructions on each progressive disclosure phase, consult:
1. [Phase 1: Analysis & Architecture Blueprint](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/references/phase1-analysis-and-architecture.md)
2. [Phase 2: Implementation & Safe Refactoring Protocol](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/references/phase2-implementation-refactoring.md)
3. [Phase 3: AI Knowledge Guardian & Control Plane](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/references/phase3-knowledge-guardian-manifest.md)
4. [Hotel Events Documentation Hierarchy & Loading Order](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/references/hotel-events-hierarchy.md)
5. [AI Manifest Template](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/PROGRESSIVE-DISCLOSURE-SKILL/examples/AI_MANIFEST_TEMPLATE.toml)
