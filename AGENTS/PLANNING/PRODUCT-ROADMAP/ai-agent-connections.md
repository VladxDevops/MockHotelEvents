+++
title = "AI agent connections and scenarios"
domain = "planning"
topics = ["planning", "ai-agents", "sales", "connections", "mcp", "approvals"]
difficulty = "intermediate"
progressive_tier = "Tier 2"
parent = "AGENTS/PLANNING/PRODUCT-ROADMAP/product-ROADMAP.md"
children = []
related = [
    "Agents.md",
    "DOCUMENTATION/INTERNAL/spects.md",
    "DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md",
    "DOCUMENTATION/INTERNAL/security.md",
    "APPS/SALESFORCE/README.md",
    "APPS/APIgee/README.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`product-ROADMAP.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/PLANNING/PRODUCT-ROADMAP/product-ROADMAP.md)  
> **Related**: [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md) | [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/SALESFORCE/README.md) | [`README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/APPS/APIgee/README.md)  
> **Progressive Tier**: Tier 2

<!-- AI RETRIEVAL HINTS:
- Purpose: Plans which connections a hotel can enable so people can use one or more AI agents against the wedding inquiry flow.
- Questions Answered: Which connection types can be turned on for an AI agent? What happens when sales uses several agents? Which other roles can use agents?
- When to Retrieve: Planning agent access, tool allow-lists, Salesforce copilots, or human approval before a booking.
- When NOT to Retrieve: Implementing a specific API, Terraform module, or model-training pipeline.
-->

# AI agent connections and scenarios

## Planning decision
People at the hotel may already work with one or more AI agents. This project stays friendly to that by treating every agent as another client of the existing boundaries: Salesforce for the customer and sales record, Apigee for northbound calls, MuleSoft for orchestration, Pub/Sub and Kafka for asynchronous work, and Redis only as a cache.

An agent does not become a system of record. It does not book a wedding, override a price, cancel a hold, or message a guest unless a named connection is enabled and the action follows the same approval path a person would use. The canonical journey stays in [`spects.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/spects.md).

Two kinds of agent are in scope, and they do not share credentials:

- **Business agents** help hotel staff or guests with inquiries, quotes, and operations.
- **Engineering agents** help maintainers of this repository. They use the skills under `AGENTS/SKILLS/`. They are not granted CRM or booking tools.

## What "friendly" means
A connection is friendly when an agent can use it without a private back door.

- Each action is an existing versioned API operation or event, with a stable name.
- Writes carry an idempotency key so a retried agent call does not create a second inquiry, quote, or booking.
- The acting person, the agent identity, the hotel (tenant), and the correlation id are recorded on the call.
- Tool results are small. They return the fields the task needs, and they label cached availability with the time it was read.
- Errors say whether the call can be retried.
- OpenTelemetry trace context continues across the agent call and the downstream event.
- Connections are off until a hotel enables them, and DEV may enable a wider set than PROD.

## Connection types that can be added and enabled
Each row is a switch. Enabling it grants a named tool group to a named agent role. It does not grant the rest of the platform.

| Connection | Direction | Enable when | Default mode |
| :--- | :--- | :--- | :--- |
| Northbound API tools | Agent calls Apigee using the published OpenAPI operations for inquiry, availability, quote, and booking. | The agent runtime can call HTTPS and should use the same gateway as other clients. | Read, plus draft writes. Confirm and cancel stay off. |
| MCP tool server | The agent's host exposes Model Context Protocol tools that call those same APIs. | Sales or operations already run an assistant that attaches MCP servers. | Same allow-list as the API tools. MCP is a transport, not a second contract. |
| CRM user connection | The agent acts as the signed-in salesperson through a Salesforce connected app or an equivalent CRM OAuth grant. | The person works inside Salesforce, Agentforce, Einstein, or a desktop assistant tied to their user. | Read their own leads and opportunities. Stage changes and booking status need approval. |
| CRM event subscription | Salesforce platform events or outbound messages notify the agent when a lead or opportunity changes. | The agent should wake up on CRM activity rather than poll. | Read-only notification. |
| Service identity | A dedicated runtime identity calls MuleSoft or GCP on behalf of a workflow, not a person. | The agent runs unattended, such as a nightly pipeline summary. | Least privilege, one service account per agent role. |
| Event subscription | The agent consumes an allow-listed Pub/Sub subscription or Kafka topic (`lead.created`, `event.quote.generated`, `event.booking.confirmed`, `event.operations.handoff`). | The agent reacts after the platform has already committed the fact. | Consume and draft a follow-up. Do not treat the event as permission to commit a second fact. |
| Channel outbound | The platform or the agent opens a draft in Salesforce, email, Slack, or Teams. | A person expects the agent's work in the tool they already use. | Draft only. Sending to a guest is a separate enabled action. |
| Knowledge retrieval | The agent reads published contracts, package descriptions, runbooks, and this planning set. | The agent needs policy or schema context. | Read-only corpus. Secrets and unpublished pricing rules stay out of the corpus. |
| Cache read | The agent reads a Redis availability or package summary through an API, not by opening Memorystore directly. | A salesperson needs a fast date check. | Read-only, and the response states that Redis is a cache. |
| Analytics read | The agent queries a named BigQuery view for conversion, occupancy, or cycle time. | A manager wants an explanation of pipeline health. | Named views only. |
| Document access | The agent reads or stores a proposal file in a scoped Cloud Storage prefix. | Quotes become documents the salesperson reviews. | Read, or write into a draft prefix. Signed contracts stay on the booking path. |
| Approval gate | A person must accept before the enabled write runs. | The action commits money, inventory, a customer message, or a cancellation. | Required for quote send, booking confirm, price override, and guest notification. |
| Observability read | The agent reads traces, metrics, or dead-letter depth for its own hotel and environment. | An operator asks why an inquiry stalled. | Read-only. Replay and infrastructure changes stay behind their own gate. |
| Agent handoff event | One agent publishes a typed handoff that another agent, or a person, picks up. | Several specialists work the same inquiry. | The handoff carries the inquiry id and the requested next step. Shared scratch memory is not the handoff. |

Direct database credentials, raw Redis admin, Terraform apply, and secret-manager reads are not agent connections. Those stay on the human and GitOps paths described in [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md).

## How an enablement record looks
A hotel turns connections on per agent role, environment, and action mode. `read` returns data. `propose` creates a draft a person can see. `commit` changes a system of record and is allowed only where the table above leaves it on.

```yaml
agent_role: sales_copilot
environment: dev
identity: user_delegated   # the signed-in salesperson
hotel_scope: hotel_demo
connections:
  northbound_api:
    enabled: true
    allow: [inquiries.read, inquiries.create, availability.read, quotes.draft]
    deny: [bookings.confirm, bookings.cancel]
  mcp:
    enabled: true
    tools_from: northbound_api
  crm_user:
    enabled: true
    allow: [leads.read, opportunities.read, tasks.draft]
  events_in:
    enabled: true
    topics: [event.inquiry.received, event.quote.generated]
  channels_out:
    enabled: true
    targets: [salesforce_task, email_draft]
  approval_required:
    - quotes.send
    - opportunities.stage_change
```

A second agent for the same person gets its own record. Overlapping write tools are avoided. If two agents can both draft a quote, the quote API still idempotently keys on inquiry id plus revision, and only one draft is current.

## Primary scenario: sales uses one or more agents
A salesperson qualifies wedding inquiries, checks dates, and prepares a proposal. They may use a single copilot or a small set of specialists.

| Agent | Enabled connections | What it may do | What stays with the person |
| :--- | :--- | :--- | :--- |
| Inquiry concierge | CRM read, inquiry create/read, channel draft | Capture a call or email into an inquiry and open a Salesforce follow-up draft. | Deciding that the lead is real and which hotel owns it. |
| Availability assistant | Availability read, cache read through that API | Answer "is the ballroom free on these dates?" with a timestamped cache or source result. | Promising the date to the guest. |
| Proposal drafter | Package read, quote draft, document draft | Assemble a package and price draft from the quote rules. | Sending the quote and changing the opportunity stage. |
| Follow-up assistant | Event subscription, CRM task draft | Remind the salesperson when a quote has had no reply. | Contacting the guest outside an approved template. |

They cooperate through the inquiry id and the handoff event. They do not pass booking rights to each other. A sales manager can enable a separate read-only pipeline agent for their own user, with analytics read and CRM read, and without quote draft.

## Other scenarios worth enabling later
These use the same connection types with different allow-lists.

1. **Guest concierge.** A visitor on the landing page asks about dates and packages. Enable a narrow Apigee client with quota and spike arrest, inquiry create, and availability read. No CRM browse, no cache credentials, no commit.
2. **Sales manager approvals.** Enable CRM read, quote read, and the approval gate. The agent summarizes a proposal. The manager's approval is the commit.
3. **Event operations.** After `event.booking.confirmed`, an operations agent reads the handoff event and drafts staffing, rooming, and catering tasks. It does not change the booking.
4. **Catering and vendor partner.** A partner agent receives only the fields its contract allows, through a dedicated Apigee product. It can accept or decline a work request. It cannot read unrelated guests.
5. **Revenue assistant.** Analytics read and package read. It can propose a price band. Publishing a price change is a commit and stays off.
6. **Guest communications.** After a booking, enable template drafts for reminders. Sending is a separate connection and requires the guest's existing consent flag on the booking.
7. **Hotel administrator.** Enable tenant configuration reads and drafts for packages, rooms, and cancellation rules. Guest records stay out of this role. Publishing configuration follows the GitOps path.
8. **Platform operator.** Observability read for one environment. Replaying a dead-letter message is its own gated connection. Changing infrastructure is not an agent connection.
9. **Implementation consultant.** For a new hotel, enable knowledge retrieval and non-production API tools in DEV. Production CRM and booking connections stay off until that hotel's enablement record is reviewed.
10. **Engineering agent.** Repository skills, schema docs, and plan-only infrastructure review. No business connection from the table above is enabled for this role.

## Multiple agents on one inquiry
Preferred pattern: specialists with narrow connections, coordinated by events.

- The inquiry concierge creates the inquiry.
- The availability assistant answers from the availability API.
- The proposal drafter writes one current quote draft.
- A person sends the quote.
- The follow-up assistant subscribes to `event.quote.generated`.
- Operations starts only on `event.booking.confirmed`.

A single agent with many tools is also valid for a small sales team. The enablement record should still split read, propose, and commit so adding a second agent later does not require a new API.

Conflict rule: inventory and booking have one writer, the booking path. Agents may read holds and draft requests. Two agents cannot both confirm the same date.

## Rollout order
1. Publish the OpenAPI operations and event names agents will call. Keep them identical to the human-facing contracts.
2. Add the sales copilot enablement record in DEV with read and draft only.
3. Add MCP as a wrapper over those operations if the sales team uses an MCP-capable assistant.
4. Add CRM user delegation so the audit trail shows the salesperson, not a shared bot user.
5. Add the approval gate for quote send.
6. Enable the guest concierge only after Apigee quota, schema validation, and PII minimization are in place.
7. Add operations, vendor, and analytics roles one at a time, each with its own identity.

## Success signals
- A salesperson can complete inquire, check dates, and draft a quote from an agent without a new integration path.
- A second sales agent can be added by copying an enablement record and narrowing tools.
- Booking confirmations still show a human approval id.
- Traces show agent id, user, hotel, and inquiry id on the same span lineage.
- A disabled connection fails closed with a structured error the agent can explain to the user.

## Related docs
- [`product-ROADMAP.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/AGENTS/PLANNING/PRODUCT-ROADMAP/product-ROADMAP.md)
- [`architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/ARCHITECTURE/architecture.md)
- [`security.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/DOCUMENTATION/INTERNAL/security.md)
