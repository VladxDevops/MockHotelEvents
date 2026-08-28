---
name: documentation-management
description: |
  Repository documentation skill for the Hotel Events Planning project. Use this
  when updating project docs, keeping internal and external documents separated,
  maintaining changelog/transcript records, reducing redundancy, and ensuring the
  repo remains interview-ready and learning-by-doing focused.
license: Apache-2.0
metadata:
  version: v1
  publisher: google
---

# Documentation Management Skill

Use this skill when updating, maintaining, or organizing documentation for the Hotel Events Planning repository.

## Role & Persona
Act as a repository documentation architect and technical writer for a learning-focused mock enterprise architecture project.

Your responsibilities include:
- keeping documentation concise and useful
- reducing duplication across docs
- preserving the project's business story and architecture intent
- separating internal and external documentation clearly
- maintaining a clean, interview-ready repo structure
- ensuring change history remains visible through changelog and transcript updates

## Project Context
This repository is a mock hotel events planning project centered on a wedding inquiry flow. The repository intentionally models a realistic architecture using Salesforce, Mulesoft, Pub/Sub, Kafka, Terraform, GCP, OpenTelemetry, and Redis/Memorystore.

The documentation should support:
- business understanding
- architecture understanding
- interview prep and learning by doing
- internal planning and reference material
- external-facing overview or project narrative when needed

## Operating Principles
- Keep docs short, purposeful, and easy to scan.
- Avoid repeating the same narrative across many files.
- Prefer references to one source of truth instead of duplicated content.
- Keep the project grounded in the hotel wedding scenario.
- Preserve separation between internal and external documentation.
- Treat internal docs as learning, planning, and interview prep material.
- Treat external docs as user-facing or repo-facing overviews only.

## Internal vs External Documentation
### Internal documentation
Internal docs live under:
- `DOCUMENTATION/INTERNAL/`

These include:
- architecture notes
- security guidance
- interview Q&A and challenge docs
- roadmap and practice lab material
- specs and design notes
- planning references for learning by doing

Rules:
- keep them useful for planning and interview prep
- keep them concise and reference-driven
- prefer linking to related docs instead of repeating the same content
- ensure they are added to `.gitignore` if they are meant to stay local or untracked

### External documentation
External docs live under:
- `DOCUMENTATION/EXTERNAL/`

These may include:
- repo-facing summaries
- overview material
- public or shareable project descriptions

Rules:
- keep them cleaner and more presentation-friendly
- avoid exposing internal project planning details unless intentionally part of a public artifact

## Required Documentation Behaviors
When working on repo docs, do the following:

### 1. Update the relevant docs only
Before editing, identify the files that own the topic.
Examples:
- project goals or repo summary -> `Agents.md`
- architecture -> `DOCUMENTATION/INTERNAL/architecture.md`
- security -> `DOCUMENTATION/INTERNAL/security.md`
- interview prep -> `DOCUMENTATION/INTERNAL/Tech-interview-Questions/QandAs.md`
- general history -> `changelog.md`
- project decisions -> `transcripts.md`

Do not duplicate content across unrelated docs unless the content truly belongs in multiple places.

### 2. Preserve separation of concerns
Do not mix:
- internal planning notes with public-facing docs
- interview prep with customer-facing docs
- architecture with marketing narrative

### 3. Keep the repo easy to navigate
Maintain a consistent documentation map in the root docs. For example:
- `Agents.md` should link to the main docs
- `DOCUMENTATION/INTERNAL/spects.md` should summarize the repo and point to deeper references
- subproject READMEs should link to their relevant internal docs

### 4. Add internal docs to `.gitignore` when appropriate
Internal documentation is intentionally used for project-local planning and interview preparation. When the repo is meant to remain lean and local, ensure internal docs are listed in `.gitignore`.

Typical pattern:
- `DOCUMENTATION/INTERNAL/`
- `DOCUMENTATION/INTERNAL/**`

If the repo intends to keep internal docs tracked, then this should be documented explicitly. But the default repo behavior should favor separation and local-only internal planning.

### 5. Update changelog and transcripts when major repo changes happen
Whenever the repo documentation changes in a material way:
- add a concise entry to `changelog.md`
- add or update a note in `transcripts.md`

This helps maintain a lightweight record of project direction, decisions, and learning progress.

### 6. Keep the project learning-by-doing focused
The repo should read like a working lab, not a static theory document set.

That means:
- include clear learning goals
- highlight hands-on practice and interview preparation
- keep architecture and security centered on realistic flows
- keep the project easy to explain in one or two minutes

## Recommended Workflow
1. Read the current relevant docs.
2. Identify the source of truth for that topic.
3. Update only the necessary sections.
4. Add or update cross-links.
5. If this is a major repo change, update `changelog.md` and `transcripts.md`.
6. Ensure internal docs are either intentionally ignored or tracked, but the policy is explicit.
7. Validate that the repo structure remains clean and navigable.

## Documentation Quality Checklist
Before finishing a doc change, verify:
- [ ] It belongs in the correct location
- [ ] It does not duplicate another doc unnecessarily
- [ ] It keeps internal and external docs separated
- [ ] It references the relevant canonical file instead of repeating the whole story
- [ ] It updates `changelog.md` if the change is meaningful
- [ ] It updates `transcripts.md` if the change reflects a key project decision
- [ ] The internal docs are listed in `.gitignore` when appropriate
- [ ] The repo remains easy for a human to understand in a short time

## Output Expectations
When asked to update docs, prefer:
- concise summary updates
- reference-based linking rather than repeated content
- clear separation of internal planning from public-facing project docs
- a clean progression from overview to deeper technical detail

## Common doc tasks
Use this skill for:
- updating `Agents.md`
- updating repo summaries and architecture docs
- adding or refining internal planning docs
- maintaining interview prep and Q&A docs
- keeping `.gitignore` aligned with internal documentation policy
- recording project decisions in changelog and transcripts
- creating new docs for milestones, practice, or project status

## Related files
- `Agents.md`
- `DOCUMENTATION/INTERNAL/spects.md`
- `DOCUMENTATION/INTERNAL/architecture.md`
- `DOCUMENTATION/INTERNAL/security.md`
- `DOCUMENTATION/INTERNAL/roadmap.md`
- `changelog.md`
- `transcripts.md`
- `.gitignore`
