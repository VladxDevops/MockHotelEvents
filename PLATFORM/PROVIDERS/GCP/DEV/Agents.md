+++
title = "PLATFORM / PROVIDERS / GCP / DEV - AI Agent Guide"
domain = "infrastructure"
topics = ["dev", "environment", "gcp", "terraform", "agents"]
difficulty = "advanced"
progressive_tier = "Tier 3"
parent = "PLATFORM/PROVIDERS/GCP/Agents.md"
children = []
related = [
    "PLATFORM/PROVIDERS/GCP/Agents.md",
    "PLATFORM/PROVIDERS/GCP/DEV/README.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md",
    "PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md"
]
updated_by = "AI Context Specialist"
version = "1.0"
+++

> **Parent**: [`PLATFORM/PROVIDERS/GCP/Agents.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/Agents.md)  
> **Related**: [`DEV/README.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/DEV/README.md) | [`TERRAFORM/terragrunt.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md) | [`TERRAFORM/dev-environment-starter-architecture.md`](file:///home/pochitawork/InterviewCloudProjects/HOTELevents/PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md)  
> **Progressive Tier**: Tier 3

<!-- AI RETRIEVAL HINTS:
- Purpose: Routes AI agent requests related to the DEV environment, development infrastructure, and rapid iteration patterns.
- Questions Answered: What is the DEV environment configured for, and how do I deploy to it?
- When to Retrieve: Working on development infrastructure, initial implementation, or testing new patterns.
- When NOT to Retrieve: Working on production or staging deployments, or application code (non-infrastructure).
-->

# PLATFORM / PROVIDERS / GCP / DEV - AI Agent Guide

This guide helps AI agents understand and work within the DEV environment for the Hotel Events GCP infrastructure.

## DEV environment purpose

The DEV environment is optimized for:

- **Rapid iteration** on infrastructure and application code
- **Feature testing** and proof-of-concept validation
- **Developer experience** over cost optimization
- **Quick feedback loops** and deployment cycles
- **Onboarding** new team members to cloud infrastructure patterns

DEV is **not** production-grade and **not** designed for high availability or strict governance.

## Environment characteristics

| Aspect | DEV Setting | Notes |
| :--- | :---: | :--- |
| Region | `us-central1` | Fixed, close to US users |
| Availability | Zonal | Single zone, no redundancy |
| Resource sizing | Small | Cost-optimized for development |
| Backup strategy | Optional | Manual or no backup for speed |
| Access controls | Relaxed | Developer-friendly permissions |
| Approval gates | Minimal | Automatic deploy on merge |
| Log retention | 30 days | Short for development verbosity |
| Cost target | $50-200/month | Minimal and experimental |
| Auto-cleanup | Enabled | Scheduled shutdown if available |

## Folder structure

### DEV configuration location

```
PLATFORM/PROVIDERS/GCP/
  ├── DEV/
  │   ├── README.md               (environment context and governance)
  │   └── dev.tfvars              (environment-specific variables, empty initially)
  ├── live/
  │   └── dev/                    (Terragrunt DEV environment folder)
  │       ├── terragrunt.hcl      (DEV overrides)
  │       ├── region.hcl
  │       ├── network/
  │       │   └── terragrunt.hcl  (network component for DEV)
  │       ├── iam/
  │       ├── messaging/
  │       ├── cache/
  │       ├── monitoring/
  │       └── cloudrun/
  └── modules/
      ├── network/
      ├── iam/
      ├── pubsub/
      └── ...
```

### Key files
- `PLATFORM/PROVIDERS/GCP/DEV/README.md` — Environment context and governance
- `PLATFORM/PROVIDERS/GCP/live/dev/terragrunt.hcl` — DEV Terragrunt root (to be created)
- `PLATFORM/PROVIDERS/GCP/live/dev/{component}/terragrunt.hcl` — Component configs (to be created)
- `PLATFORM/PROVIDERS/GCP/modules/{component}/` — Reusable modules for all environments

## DEV infrastructure components

### Network
- Single VPC in `us-central1`
- Basic firewall rules (permissive for development)
- Application and data subnets
- Private service access enabled

### IAM and service accounts
- Service account per component (inquiry, availability, pricing, booking, operations)
- Developer service account with broad local permissions
- No cross-environment access restrictions
- Local IAM bindings only

### Messaging (Pub/Sub)
- Core event topics: lead, inquiry, availability, quote, booking, handoff
- Basic subscriptions for testing
- Optional dead-letter topic
- No retention or complex retry policy

### Cache (Redis)
- Single-node Memorystore instance (small size)
- Basic memory allocation (2-4 GB typical)
- No backups or replication
- TTL policies for auto-expiry

### Database (if needed)
- Cloud SQL or lightweight relational database
- Single-zone, single-instance
- Optional backups
- Development-grade connection pool

### Application services
- Cloud Run services for key workflows
- Small instance counts (1 replica minimum)
- Relaxed timeout values for debugging
- Development environment variables passed directly

### Observability
- Cloud Logging with 30-day retention
- Basic Cloud Monitoring dashboards
- Cloud Trace for debugging
- OpenTelemetry instrumentation (development/verbose level)

## Deployment to DEV

### Setup steps

```bash
# 1. Authenticate to GCP
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
gcloud config set project hotel-events-dev

# 2. Navigate to DEV Terragrunt folder
cd PLATFORM/PROVIDERS/GCP/live/dev

# 3. Initialize Terragrunt
terragrunt init

# 4. Review all components
terragrunt run-all plan
```

### Deploy a single component

```bash
# Deploy just the network
cd PLATFORM/PROVIDERS/GCP/live/dev/network
terragrunt plan
terragrunt apply

# Deploy just messaging (Pub/Sub)
cd ../messaging
terragrunt plan
terragrunt apply
```

### Deploy all components

```bash
cd PLATFORM/PROVIDERS/GCP/live/dev
terragrunt run-all apply
```

### Destroy all DEV resources (cleanup)

```bash
cd PLATFORM/PROVIDERS/GCP/live/dev
terragrunt run-all destroy
```

## DEV access and authentication

### For agents
- Use the configured GCP project ID: `hotel-events-dev`
- Use service account credentials from GCP Secret Manager
- Refer to `PLATFORM/PROVIDERS/GCP/SECURITY/` for IAM policy specifics

### For developers
- Local gcloud CLI authentication: `gcloud auth application-default login`
- Or service account key: `gcloud auth activate-service-account --key-file=...`
- Broad permissions within DEV (fine-grained in higher environments)

### Secrets management
- All integration credentials in GCP Secret Manager
- Never commit secrets to Git
- Reference secrets in Terraform via `google_secret_manager_secret` data source

## DEV-specific workflows

### Testing infrastructure changes
1. Make change to Terraform module or Terragrunt config
2. Run `terragrunt plan` to preview changes
3. Run `terragrunt apply` to deploy to DEV
4. Test the change manually or via CI
5. Once validated, commit and promote to higher environments

### Resetting DEV
Sometimes it's faster to reset DEV and start fresh:

```bash
# Destroy all resources
cd PLATFORM/PROVIDERS/GCP/live/dev
terragrunt run-all destroy

# Remove Terraform state files
rm -rf .terraform/ terraform.tfstate*

# Redeploy from scratch
terragrunt run-all init
terragrunt run-all apply
```

### Debugging failed deployments
1. Check logs: `gcloud logging read "resource.labels.project_id=hotel-events-dev" --limit 50`
2. Check specific resource: `gcloud {service} describe {resource} --project hotel-events-dev`
3. Review Terraform state: `terragrunt state show`
4. Check GCP console for resource errors in real time

### Cost monitoring
- Set up billing alerts in GCP Console
- Monitor Cloud Run and database costs most closely
- Auto-cleanup prevents runaway resource costs
- Consider scheduled shutdown during off-hours if needed

## Transition from DEV to TEST

Once DEV is stable:
1. Copy the `live/dev/` folder structure to `live/test/`
2. Update `test/terragrunt.hcl` with TEST-specific settings
3. Increase resource sizing for TEST (more realistic)
4. Add stricter IAM and validation rules
5. Document TEST environment in `TEST/README.md`
6. Follow the promotion workflow with CI/CD gates

## Related documentation

- `README.md` (this folder) — Environment context and governance
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/terragrunt.md` — Terragrunt installation and usage
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md` — Overall folder organization
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/dev-environment-starter-architecture.md` — DEV architecture design
- `PLATFORM/PROVIDERS/GCP/TERRAFORM/cloud-infrastructure-checklist.md` — Full infrastructure checklist

## Next steps for agents

1. **Understand DEV context**: Read `PLATFORM/PROVIDERS/GCP/DEV/README.md`
2. **Plan Terragrunt folders**: Review `PLATFORM/PROVIDERS/GCP/TERRAFORM/folder-structure.md`
3. **Create root Terragrunt config**: Set up `live/terragrunt.hcl`, `account.hcl`, `region.hcl`
4. **Create DEV Terragrunt config**: Set up `live/dev/terragrunt.hcl`
5. **Create first module**: Implement `modules/network/` with Terraform
6. **Create component config**: Create `live/dev/network/terragrunt.hcl`
7. **Test locally**: Run `terragrunt plan` and `terragrunt apply`
8. **Integrate with CI/CD**: Connect deployment pipeline to Terragrunt commands

