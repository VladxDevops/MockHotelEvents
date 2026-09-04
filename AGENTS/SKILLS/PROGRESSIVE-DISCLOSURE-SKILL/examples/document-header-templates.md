# Document Header & Metadata Templates
# Hotel Events Planning Project

This guide provides drop-in templates for TOML front matter, breadcrumbs, and AI retrieval hints tailored for each component in the Hotel Events Planning project.

---

## 1. Subproject / Implementation Template (Tier 3)

Use for files in `SUBPROJECTS/` (e.g., Salesforce, MuleSoft, Kafka, Redis):

````markdown
+++
title = "Kafka Wedding Inquiry Topic & Schema Definitions"
domain = "messaging"
topics = ["kafka", "pubsub", "event-streaming", "schemas", "wedding-inquiry"]
difficulty = "intermediate"
parent = "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md"
children = []
related = [
    "SUBPROJECTS/Mulesoft/README.md",
    "SUBPROJECTS/REDIS/README.md",
    "PLATFORM/TERRAFORM/cloud-infrastructure-checklist.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md)  
> **Related**: [`Mulesoft/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/SUBPROJECTS/Mulesoft/README.md) | [`REDIS/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/SUBPROJECTS/REDIS/README.md)  
> **Infrastructure**: [`cloud-infrastructure-checklist.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/TERRAFORM/cloud-infrastructure-checklist.md)

<!-- AI RETRIEVAL HINTS:
- Purpose: Specifies Kafka topic partition strategies, event retention, and message contracts for wedding inquiries.
- Questions Answered: What topic receives the wedding inquiry? How are correlation IDs partitioned? What is the consumer retry strategy?
- When to Retrieve: Designing event consumers, configuring Kafka brokers, or debugging event delivery lag.
- When NOT to Retrieve: Authoring Salesforce Apex triggers or frontend landing page mockups.
-->
````

---

## 2. Platform / Infrastructure Template (Tier 3)

Use for files in `PLATFORM/` (e.g., Terraform, Observability, Cloud IAM):

````markdown
+++
title = "GCP Cloud Memorystore (Redis) Terraform Module"
domain = "infrastructure"
topics = ["terraform", "gcp", "redis", "memorystore", "networking", "iac"]
difficulty = "advanced"
parent = "PLATFORM/TERRAFORM/cloud-infrastructure-checklist.md"
children = []
related = [
    "SUBPROJECTS/REDIS/README.md",
    "DOCUMENTATION/INTERNAL/security.md"
]
updated_by = "DevOps Platform Engineer"
version = "1.0"
+++

> **Parent**: [`cloud-infrastructure-checklist.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/TERRAFORM/cloud-infrastructure-checklist.md)  
> **Security Guardrail**: [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md)  
> **Component Specs**: [`REDIS/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/SUBPROJECTS/REDIS/README.md)

<!-- AI RETRIEVAL HINTS:
- Purpose: Provisions private Google Cloud Memorystore Redis instance with VPC peering for transient event caching.
- Questions Answered: How is Redis provisioned via Terraform? What tier and memory capacity are configured? How is private service access enabled?
- When to Retrieve: Modifying Terraform infrastructure, inspecting GCP network peering, or adjusting Redis capacity.
- When NOT to Retrieve: Analyzing Salesforce lead qualification stages or writing MUnit tests.
-->
````

---

## 3. Practice Lab / Troubleshooting Template (Tier 4)

Use for files in `TROUBLESHOOTING/` or `practice-lab.md`:

````markdown
+++
title = "Practice Lab Drill: Kafka Consumer Group Rebalance Lag"
domain = "observability-troubleshooting"
topics = ["kafka", "opentelemetry", "troubleshooting", "practice-lab", "consumer-lag"]
difficulty = "advanced"
parent = "DOCUMENTATION/INTERNAL/practice-lab.md"
children = []
related = [
    "AGENTS/SKILLS/TROUBLEMAKER/SKILL.md",
    "SUBPROJECTS/KAFKA/README.md",
    "PLATFORM/OBSERVABILITY/README.md"
]
updated_by = "SRE & Practice Lead"
version = "1.0"
+++

> **Parent**: [`practice-lab.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/practice-lab.md)  
> **Troublemaker Skill**: [`TROUBLEMAKER/SKILL.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/SKILLS/TROUBLEMAKER/SKILL.md)  
> **Messaging Spec**: [`KAFKA/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/SUBPROJECTS/KAFKA/README.md)

<!-- AI RETRIEVAL HINTS:
- Purpose: Hands-on lab exercise simulating Kafka consumer lag caused by slow downstream hotel billing checks.
- Questions Answered: How to diagnose high lag using OpenTelemetry traces? How to scale consumer replicas in GKE?
- When to Retrieve: Practicing system design interview scenarios or debugging asynchronous message bottlenecks.
- When NOT to Retrieve: Ingesting high-level project goals or review-only documentation audits.
-->
````
