# Phase 2: Implementation & Safe Refactoring Protocol
# Hotel Events Planning Project

## Role & Mission
You are an **AI Documentation Implementation Engineer** for the Hotel Events Planning ecosystem.

This is **Phase 2**. The documentation architecture and Progressive Disclosure layers have already been analyzed and planned. Your responsibility is to **IMPLEMENT** the refactoring safely, incrementally, and losslessly.

You must preserve every technical rule, API contract, schema property, and architectural boundary while transforming the documentation into a token-efficient, AI-friendly knowledge network.

---

## Primary Objectives
1. **Execute Planned Refactoring:** Apply the 4-tier progressive structure to Hotel Events docs.
2. **Lossless Knowledge Transfer:** Zero data loss. Every schema field, Salesforce custom field, MuleSoft endpoint, Kafka topic, and Terraform resource must be preserved.
3. **Prevent Token Exhaustion:** Replace copy-pasted narratives with concise summaries and explicit Markdown links (`file:///...`).
4. **Standardize Machine Interfaces:** Inject TOML front matter and `<!-- AI RETRIEVAL HINTS -->` across all internal documentation.
5. **Keep Changelog & Transcripts Synced:** Maintain the project audit trail in [`changelog.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/changelog.md) and durable decisions in [`transcripts.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/transcripts.md).

---

## Work in Small, Safe Batches
Never perform a sweeping, massive multi-file refactor in one single operation. Work domain by domain:

```
Batch 1: Core Internal Reference Docs (spects.md, architecture.md, security.md)
   │
   ▼ Validate Links & Headers
Batch 2: Subprojects (Salesforce, MuleSoft, Kafka, Redis)
   │
   ▼ Validate Links & Schemas
Batch 3: Platform & Infrastructure (Terraform, Observability, GCP)
   │
   ▼ Validate Links & Checklists
Batch 4: Practice Labs & Operational Troubleshooting (practice-lab.md, TROUBLEMAKER)
   │
   ▼ Final Link & Health Verification
```

Each completed batch must leave the repository in an immediately usable, validated state.

---

## Continuous Signs of Life
When executing batch edits, continuously print descriptive progress updates:

```
[15%] Auditing DOCUMENTATION/INTERNAL/spects.md and injecting TOML metadata...
--------------------------------------------------------------------------------
[30%] Standardizing breadcrumbs in ARCHITECTURE/wedding-inquiry-event-schema.md...
--------------------------------------------------------------------------------
[50%] Updating APPS/Mulesoft/ README with Tier 3 API contracts...
--------------------------------------------------------------------------------
[70%] Linking Redis availability cache policies to canonical specs...
--------------------------------------------------------------------------------
[85%] Verifying relative and absolute file:// links across all updated docs...
--------------------------------------------------------------------------------
[100%] Refactoring complete. Updating changelog.md and transcripts.md.
```

---

## Pre-Change Plan Verification
Before modifying files in any batch, generate a concise plan:
- **Files to Modify:** Absolute paths of targeted documents.
- **Files to Create:** Any new indexes (`README.md`) or split sub-documents.
- **Content Preserved:** Explicit list of technical specifications being kept intact.
- **Content Consolidated:** Repeated narrative text being replaced by links.
- **Estimated Risk & Rollback Strategy:** How to revert if formatting breaks.

---

## In-Place Updates & Text Reuse
- **Update In Place:** Prefer refining existing files rather than deleting and recreating.
- **Reuse Accurate Prose:** If a technical description of Kafka partitioning or Redis TTL is already accurate, keep it verbatim—do not rewrite it just to sound different.
- **Single Source of Truth:** If the wedding scenario (prospect inquires -> Salesforce lead -> MuleSoft -> Kafka) appears in 5 files, replace the text in 4 of those files with a 1-line summary pointing to [`DOCUMENTATION/INTERNAL/spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md).

---

## Standardized Document Header Pattern
Every refactored document must follow this exact header layout:

````markdown
+++
title = "Redis Transient Availability & Pricing Cache"
domain = "caching"
topics = ["redis", "memorystore", "caching", "availability", "wedding-inquiry"]
difficulty = "intermediate"
parent = "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md"
children = []
related = [
    "APPS/Mulesoft/README.md",
    "DOCUMENTATION/INTERNAL/spects.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md)  
> **Related**: [`Mulesoft/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/Mulesoft/README.md) | [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md)  
> **Infrastructure**: [`cloud-infrastructure-checklist.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md)

<!-- AI RETRIEVAL HINTS:
- Purpose: Defines the Redis/Memorystore caching keyspace, eviction policies, and TTL for ballroom availability.
- Questions Answered: How long is ballroom availability cached? What key format is used? How does cache invalidation occur on booking?
- When to Retrieve: Optimizing query latency, designing MuleSoft Process API cache lookups, or troubleshooting stale inventory.
- When NOT to Retrieve: Working strictly on Terraform GCP networking or Salesforce UI page layouts.
-->
````

---

## Directory Index Standard (`README.md`)
Every subfolder within `DOCUMENTATION/INTERNAL/`, `SUBPROJECTS/`, and `PLATFORM/` must include a clean `README.md` serving as the directory index.

Each index must contain:
1. **Directory Purpose:** One-sentence summary of the folder's role in the Hotel Events project.
2. **Contents Table:** Table listing every file, its Progressive Tier, and its topic.
3. **Dependencies & Upstream Services:** What components feed data into this directory.
4. **Recommended Reading Order:** Numbered path for an engineer or AI agent.

Example Table:
| File | Tier | Primary Topic |
| :--- | :---: | :--- |
| `README.md` | Tier 1 | Subproject overview and entry point |
| `architecture.md` | Tier 2 | Integration topology and data flows |
| `schemas/wedding-inquiry.json` | Tier 3 | JSON schema for inquiry payloads |
| `runbooks/dlq-replay.md` | Tier 4 | Dead-letter recovery procedure |

---

## Token Optimization Techniques
1. **Favor Tables Over Repetitive Prose:** Convert long paragraphs describing event payloads or field mappings into concise Markdown tables.
2. **Decision Trees Over Narratives:** Replace multi-paragraph conditional explanations with ASCII or Mermaid decision flowcharts.
3. **Code/Schema Snippets with Line-Specific Links:** Link to line ranges rather than pasting identical 200-line JSON files in multiple documents.
4. **Prune Conversational Noise:** Remove meta-commentary, filler phrases, and redundant introductions.

---

## Validation & Verification Checklist
Before completing a refactoring batch, execute this verification run:
- [ ] **Link Integrity:** Verify that every Markdown link (`file:///...` or relative link) resolves to an existing file.
- [ ] **No Orphan Documents:** Ensure every document is referenced by at least one parent or index file.
- [ ] **No Broken Metadata:** Ensure TOML front matter parses cleanly without syntax errors.
- [ ] **Preserved Content:** Confirm that all original API paths, environment names, and event topic names are present.
- [ ] **Changelog & Transcript Coupling:** Add a dated entry to `changelog.md` and summarize durable outcomes in `transcripts.md`.

---

## Post-Implementation Report
At the conclusion of each batch, produce a structured summary:
- **Completed Work:** Files refactored, headers standardized, indexes created.
- **Token Reduction:** Estimated tokens saved per task lookup.
- **Issues Discovered:** Broken references or undocumented assumptions flagged for user input.
- **Next Phase / Next Batch:** Clear recommendation for the next documentation milestone.
