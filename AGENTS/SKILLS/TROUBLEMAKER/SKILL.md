---
name: troublemaker
description: |
  Use this skill when you need to intentionally introduce a controlled failure in a
authoring workflow, integration flow, container setup, infrastructure config, or
mock runtime so that the agent can then diagnose, fix, and validate recovery.
  This is intended for safe lab-style troubleshooting, not production breakage.
license: Apache-2.0
metadata:
  version: v1
  publisher: google
---


# Troublemaker Skill

Use this skill to deliberately break a system or workflow in a safe, controlled,
reversible way so the agent can then troubleshoot the issue, fix it, and verify
recovery.

## Purpose
This skill exists to practice the operational loop of:
- controlled failure injection
- Generate Documentation for all stages of the incident. 
- evidence gathering and observability
- root-cause analysis
- targeted remediation
- validation and rollback awareness

The overall goal is not to create chaos, but to prove the ability to identify,
contain, and recover from realistic failure conditions in a mock or sandbox
environment.

## Operating principles
- Prefer DEV, TEST, local, or sandbox environments over production.
- Keep the failure isolated to one component, variable, contract, or dependency.
- Preserve a working backup or known-good state before changing anything.
- Capture logs, traces, status output, and configuration state before and after.
- Explain both the expected symptom and the real root cause.
- Fix the underlying issue, not just the visible symptom.
- Validate recovery with the smallest meaningful check.

## Standard workflow
1. Define the target
   - choose one item to fail: configuration, API contract, secret, dependency,
     Terraform variable, Redis key path, networking rule, service health check,
     event schema, container startup, or message subscription.
2. Decide the failure mode
   - example modes: missing env var, unreachable dependency, invalid topic name,
     stale cache, permission denial, schema mismatch, bad port binding, bad secret,
     syntax error, or broken IAM role.
3. Inject the issue intentionally
   - change only the minimal target area
   - log the exact change and timestamp
   - avoid unrelated edits
4. Observe and diagnose
   - inspect logs, traces, HTTP responses, Terraform output, consumer errors,
     metrics, or application health checks
   - identify the first real signal of failure
5. Fix the root cause
   - revert or correct the specific problem
   - keep the fix narrow and explainable
6. Validate recovery
   - run the smallest smoke test, health check, or workflow verification needed
   - confirm the system is behaving normally again
7. Document the learning
   - record what broke, why it broke, how it was fixed, and how to prevent it

## Behavior expected from an agent using this skill
When this skill is active, the agent should:
- clearly state which component is being broken and why
- describe the expected symptom before the failure is introduced
- gather evidence before patching
- isolate the root cause instead of guessing
- fix the smallest valid remediation
- verify that the broken path recovers cleanly
- summarize the lesson and prevention mechanism

## Safe failure patterns for this repository
For the Hotel Events Planning project, this skill is especially useful for:
- misconfiguring a mock Redis cache for availability or pricing lookup
- breaking an event schema or JSON payload in a Pub/Sub or Kafka example
- disabling a subscription or topic binding in a mock event flow
- introducing a bad API contract between Salesforce, Mulesoft, or a downstream
  service
- invalidating a Terraform variable, secret, or GCP configuration value
- causing a local Docker container or service startup failure in a mock environment
- setting an incorrect IAM, permission, or environment variable in a sandbox
- triggering a dead-letter or retry path in an event-driven integration flow
- Generate or replicate bottlenecks/latency/https errors/unexpected behabiors. 


## Recovery checklist
Only consider the exercise successful when all of the following are true:
- the failure was intentional and controlled
- the system state before the break was preserved or documented. This is super importatnt. 
- the effect was observable and understandable
- the root cause was identified with evidence
- the fix addressed the actual cause
- the system was validated after the fix
- any lingering risk, follow-up item, or guardrail was documented

## Output style
When responding with this skill, the agent should produce a concise troubleshooting
narrative in this order:
1. What and when was intentionally broken?
2. What was expected to happen?
3. What evidence confirmed the issue?
4. What was the root cause?
5. What fix was applied?
6. How was recovery validated?
7. What should be done to prevent recurrence?

## Non-goals
- Do not use this skill for destructive, malicious, or unsafe actions.
- Do not break production systems without explicit approval.
- Do not hide the issue with a random workaround.
- Do not skip the diagnosis and validation steps.
- Do not skip the documentation of the incident and lessons learned.
- Do not skip Docuemnting the previous state of the system before the break. This is super important.

## Example prompts
- "Generate a blttleneck where Redis has a concurrency of 5 and there is already too much data." 
- "Break the Redis availability cache for a wedding inquiry and then fix it."
- "Intentionally misconfigure the message topic for the event booking flow and recover it."
- "Inject a mock schema mismatch in the event payload and explain the fix."
- "Cause a local Docker service startup failure and troubleshoot the root cause."
- "Break a Terraform variable in the mock infrastructure and repair it cleanly."
- "Replicate this error/behavior the end user reported"

## Documentation generation requirement
The skill must not treat the troubleshooting exercise as complete until it has
produced documentation for the activity. Documentation should be generated as part
of the process, not as an afterthought.

The agent should create or update a persistent record that captures:
- what system or component was targeted
- what the initial desired working state was
- what was intentionally changed to create the failure
- the timestamp and reason for the break
- the exact symptom or evidence observed
- the root cause analysis and findings
- what fix was applied
- how recovery was validated
- what preventive action or guardrail should be added
- any follow-up item or rollback note

This documentation can be created in one of the following ways:

### Option 1: Markdown incident log (recommended)
Create a file in a repo-local area such as:
- `DOCUMENTATION/INTERNAL/incident-reports/`
- `AGENTS/PLANNING/TODOS/`
- `AGENTS/SKILLS/TROUBLEMAKER/logs/`

Recommended structure:
- title
- date/timestamp
- scenario and objective
- pre-failure state
- failure injection details
- observations and evidence
- root cause
- remediation
- validation
- prevention recommendations

This is the easiest option for review, demos, and interview-style documentation.

### Option 2: Runbook-style checklist
Create a lightweight operational checklist that records the exact sequence of:
- break
- observe
- diagnose
- fix
- recover
- validate

This works well for repeatable exercises and training scenarios.

### Option 3: Structured JSON or YAML artifact
Store a machine-readable incident record including fields like:
- `scenario`
- `component`
- `failure_mode`
- `expected_behavior`
- `observed_symptom`
- `root_cause`
- `fix_applied`
- `validation_steps`
- `status`

This is useful for automation, dashboards, or future retrieval.


### Option 4: Embedded session summary + repo file
The agent can provide a short summary in the chat and also save a file in the repo
with the full details. This combines fast human readability with durable artifact
storage.

## Documentation rules
- Always capture the state before the break, because that is the baseline for
  validation and rollback.
- Do not rely only on conversation memory; store the record in a file or artifact.
- Keep the documentation aligned to the hotel events scenario.
- Write the document as if another engineer will need to understand and repeat the
  exercise.
- Record both the technical cause and the business/customer impact where relevant.

## Absolute logging requirement from the first prompt onward
The agent must begin logging as soon as the skill is invoked, even before any
direct action is taken. The logging requirement is continuous and applies to the
full lifecycle of the exercise, including prompt intake, investigation, no-op
observations, failed attempts, successful remediation, and final summary.

The agent must update the following files during the exercise, without exception:
- `TROUBLESHOOTING/troublemaker/incidents/changelog-incidents.md`
- `TROUBLESHOOTING/troublemaker/incidents/transcripts-incidents.md`

This applies even when:
- no code or config changes were made
- the issue was found without a break being intentionally introduced
- the agent only investigated, observed, or evaluated a scenario
- the first prompt was simply a request to consider a risk or failure mode
- the exercise results in a no-op or a decision to stop without changing anything

### Required logging timing
The agent should record an entry:
- immediately when the troubleshooting request or prompt is received
- after every meaningful action, observation, or decision
- after each attempted fix or failed remediation step
- after every successful validation or recovery step
- at the final completion or close-out of the scenario

The log should be treated as a running operational record, not a final summary
added only at the end.

### Required content for each entry
Each log entry should include:
- timestamp
- prompt/request summary
- current intent or objective
- action taken or observation made
- whether a code/config change was made
- whether a failure was intentionally injected
- any evidence gathered
- current status or next step
- whether the scenario is ongoing, resolved, or no-op

## Mandatory changelog and transcript requirements
The troubleshooting exercise is not considered complete until the agent has
recorded the work in the required project logs.

The agent must update all of the following as part of the exercise:
- `TROUBLESHOOTING/troublemaker/incidents/changelog-incidents.md` — incident changelog
- `TROUBLESHOOTING/troublemaker/incidents/transcripts-incidents.md` — transcript log

This should happen in the same workflow as the technical documentation, not as a
separate or optional step after the fact.

### Required behavior
- Add a concise summary to the main `changelog.md` describing the failure scenario,
  root cause, remediation, and validation outcome.
- Add a dedicated incident-level entry in a file or section specifically for the
  exercise, such as an incident report, postmortem note, or scenario log.
- Add a transcript-style record to `transcripts.md` capturing the chronology of:
  - target selection
  - break injection
  - evidence collection
  - diagnosis
  - remediation
  - validation
  - lessons learned

### Logging expectations
Each entry should include enough detail for another engineer to understand:
- what happened
- why it was intentionally broken
- what the expected behavior was
- what evidence was gathered
- what the fix was
- how the fix was confirmed
- what should be improved or automated next

### Suggested structure for the incident changelog
- Incident title
- Date / timestamp
- Scope and component affected
- Trigger or failure mode
- Pre-failure baseline
- Observed symptoms
- Root cause
- Remediation steps
- Validation outcome
- Follow-up actions

### Suggested structure for transcript logging
- session start timestamp
- scenario objective
- failing component or workflow
- intentional change applied
- observed errors or symptoms
- root-cause investigation
- fix steps
- final validation
- final summary / lessons learned

## Documentation workflow inside the skill
1. Establish the starting state.
2. Record a pre-failure snapshot or expected healthy behavior.
3. Break the target system intentionally.
4. Capture the observed symptoms and evidence.
5. Diagnose and document the root cause.
6. Apply the fix and document it.
7. Validate the fix and record the proof.
8. Save the final incident record in a repo artifact.
9. Update `changelog.md` with a concise project-level entry.
10. Update the incident-level changelog with the detailed exercise record.
11. Update `transcripts.md` with the operational timeline and learning notes.
12. Summarize the lessons learned and preventions for future runs.

## Updated behavior expected from an agent using this skill
When this skill is active, the agent should:
- clearly state which component is being broken and why
- describe the expected symptom before the failure is introduced
- gather evidence before patching
- isolate the root cause instead of guessing
- generate persistent documentation for the whole exercise
- update the repository `changelog.md`
- update an incident-level changelog entry for the scenario
- update `transcripts.md` with the action trail
- fix the smallest valid remediation
- verify that the broken path recovers cleanly
- summarize the lesson and prevention mechanism

## Updated output style
When responding with this skill, the agent should produce a concise troubleshooting
narrative in this order:
1. What and when was intentionally broken?
2. What was the pre-failure baseline?
3. What was expected to happen?
4. What evidence confirmed the issue?
5. What was the root cause?
6. What fix was applied?
7. How was recovery validated?
8. What documentation artifact was generated?
9. What changelog entries were updated?
10. What transcript record was created?
11. What should be done to prevent recurrence?

## Documentation generation examples for this repo
Examples of repo-aligned output artifacts:
- `DOCUMENTATION/INTERNAL/incident-reports/redis-cache-failure.md`
- `DOCUMENTATION/INTERNAL/incident-reports/pubsub-schema-mismatch.md`
- `AGENTS/SKILLS/TROUBLEMAKER/logs/terraform-variable-break.md`
- `AGENTS/SKILLS/TROUBLEMAKER/logs/wedding-inquiry-event-failure.yaml`

These records should be written in a way that makes the incident easy to explain in
an interview, demo, or postmortem discussion.
