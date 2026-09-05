+++
title = "Troublemaker Skill"
domain = "agent-skills"
topics = ["agent-skills", "context-engineering", "runbooks", "automation", "index"]
difficulty = "intermediate"
progressive_tier = "Tier 4"
parent = "Agents.md"
children = ["AGENTS/SKILLS/TROUBLEMAKER/SKILL.md"]
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

> **Parent**: [`Agents.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/Agents.md)  
> **Related**: [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md) | [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/SALESFORCE/README.md)  
> **Progressive Tier**: Tier 4

<!-- AI RETRIEVAL HINTS:
- Purpose: Documents agent-facing skills, runbooks, and context rules used while working in this repository.
- Questions Answered: Which agent workflow or skill behavior applies to repository work?
- When to Retrieve: Working on agent skills context for the Hotel Events wedding inquiry platform.
- When NOT to Retrieve: Working on unrelated generated assets, dependency lockfiles, or implementation code that does not need documentation context.
-->
# Troublemaker Skill

A controlled failure-injection and troubleshooting skill for the Hotel Events Planning repository.

## Purpose

This skill is designed to intentionally break a component, workflow, or configuration in a safe environment so the agent can then:

- investigate the failure
- gather evidence
- identify the root cause
- apply a narrow fix
- validate recovery
- document the incident and learning

The goal is not to create chaos, but to practice realistic operational troubleshooting in a mock or sandbox environment.

## Scope

Use this skill for:

- config and env var failures
- API contract mismatches
- Redis cache or session issues
- Pub/Sub or Kafka message problems
- Terraform variable or infrastructure issues
- Docker/container startup problems
- service dependency failures
- schema or payload validation issues
- mock production-like incidents for demos or interview prep

This should be used in DEV, TEST, local, or sandbox scenarios only. Never use this skill against production systems without explicit approval.


## Required workflow

1. Define the target
   - choose a single component or workflow to break
   - keep the scope limited and intentional

2. Record the baseline
   - capture the healthy state before the break
   - note expected behavior and current config

3. Inject the failure
   - make only the minimal change needed
   - do not broaden scope or make unrelated edits

4. Observe and diagnose
   - inspect logs, traces, health checks, payloads, metrics, or service output
   - confirm the exact symptom and its source

5. Fix the root cause
   - correct the actual underlying issue
   - avoid random or broad workaround changes

6. Validate recovery
   - run the smallest meaningful verification
   - confirm the broken path is healthy again

7. Document everything
   - create or update the required incident logs and changelogs
   - capture the timeline, findings, fix, and prevention actions

## Mandatory documentation requirement

The skill is not complete until the agent has recorded the exercise in the required project logs.

The agent must update all of the following as part of the workflow:

- `TROUBLESHOOTING/troublemaker/incidents/changelog-incidents.md`
- `TROUBLESHOOTING/troublemaker/incidents/transcripts-incidents.md`

This must begin from the very first prompt or request and continue after every action, observation, decision, and no-op state.

Even if:

- no code change was made
- the issue was only investigated
- the scenario was aborted
- the failure was not reproduced
- the agent decided no fix was necessary

...the log still needs to be updated.

## Logging expectations

Each log entry should include:

- timestamp
- prompt or objective
- targeted component or workflow
- action or observation
- whether a break was intentionally introduced
- whether a change was made
- error or evidence captured
- diagnosis and root cause
- fix attempted or applied
- validation result
- outcome: resolved, ongoing, no-op, or blocked
- follow-up recommendation

## Suggested repository usage

This skill is intended to work alongside the hotel wedding event story and the repo's operational documentation. Typical examples include:

- Redis cache failure during venue or package lookup
- Pub/Sub or Kafka schema mismatch for event notifications
- Terraform variable corruption during mock infrastructure provisioning
- Docker container startup failure for local service testing
- event contract break between Salesforce and Mulesoft simulation

## Safety rules

- Prefer DEV, TEST, or local sandbox environments
- Keep the failure isolated to one system or contract
- Preserve a working baseline before changing anything
- Do not hide the issue with a workaround
- Do not skip root-cause analysis
- Do not skip documentation
- Do not break production systems without approval

## Example prompt patterns

- "Break the Redis availability cache for a wedding inquiry and then fix it."
- "Intentionally misconfigure the event payload schema and document the recovery."
- "Inject a mock Terraform variable issue and troubleshoot it safely."
- "Cause a local container startup failure and record the diagnosis in the incident logs."
- "Simulate a messaging failure in the booking flow and explain the fix."

## Output style

The agent should produce a troubleshooting narrative that includes:

1. what was intentionally broken
2. the pre-failure baseline
3. expected behavior
4. observed evidence
5. root cause
6. remediation
7. validation
8. generated documentation and changelog entries
9. lesson learned

## Related files

- `AGENTS/SKILLS/TROUBLEMAKER/SKILL.md` — formal skill definition
- `TROUBLESHOOTING/troublemaker/incidents/changelog-incidents.md` — incident changelog
- `TROUBLESHOOTING/troublemaker/incidents/transcripts-incidents.md` — transcript log

## Summary

The Troublemaker skill is a lab for controlled engineering failure: break something intentionally, prove you can diagnose it, fix it, validate it, and record the full story in the repository's changelogs and transcripts.
