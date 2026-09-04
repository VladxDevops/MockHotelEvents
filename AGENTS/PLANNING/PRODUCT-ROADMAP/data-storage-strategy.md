# Data storage strategy for the Hotel Events Planning project

## High-level answer
The project should not rely on a single database. Instead, it should use different storage types for different responsibilities.

## Recommended storage model


### 1. CRM and customer data
- Primary system: Salesforce
- Purpose: customer records, leads, opportunities, sales context
- Data type: relational/customer relationship data
- Why: Salesforce is the natural customer and sales record system for the business workflow


### 2. Integration and workflow state
- Primary system: Mulesoft orchestration layer and optional application database
- Purpose: request state, process tracking, workflow checkpoints, transformation metadata
- Data type: relational database or state-tracking store
- Recommended technology: Postgres / Cloud SQL or a lightweight operational database


### 3. Event streaming and asynchronous messaging
- Primary system: Pub/Sub and/or Kafka
- Purpose: event-driven handoff between systems
- Data type: event streams, topic messages, not the canonical transactional database
- Why: these systems carry data movement and decoupling rather than serving as the only source of truth


### 4. Caching and fast lookups
- Primary system: Redis / Memorystore
- Purpose: cached room availability, pricing summaries, event package lookups, temporary session state
- Data type: key-value or in-memory cache
- Why: Redis is optimized for speed, but it should not act as the system of record for final bookings or financial commitments


### 5. Operational reporting and analytics
- Primary system: BigQuery or similar analytics warehouse
- Purpose: trend analysis, conversion metrics, operational reporting, event summaries
- Data type: analytical data warehouse
- Why: this is useful for reporting and multi-hotel analysis after the transactional systems have handled the live workflow


### 6. Static or unstructured data
- Primary system: Cloud Storage
- Purpose: landing page assets, exported payloads, logs, backups, document attachments, schema snapshots
- Data type: object storage


## Recommended practical pattern
For a realistic mock implementation:
- Salesforce stores CRM history and pipeline information.
- A transactional database stores operational business state and workflow records.
- Pub/Sub or Kafka transports events between services.
- Redis caches frequently accessed availability and pricing data.
- BigQuery handles analytical queries across historical event data.
- GCS stores artifacts and static or exported files.


## Why this is the right pattern
This split matches enterprise architecture best practice:
- relational systems for structured, transactional data
- event brokers for decoupling and asynchronous processing
- caches for performance optimization
- analytical warehouses for reporting and BI
- object storage for files and operational artifacts


## Simple summary
For this project, the data architecture should look like a layered system rather than a single database:
- Salesforce = sales/customer layer
- database = workflow and transactional layer
- Pub/Sub/Kafka = integration/event layer
- Redis = cache layer
- BigQuery = analytics layer
- Cloud Storage = object and file layer
