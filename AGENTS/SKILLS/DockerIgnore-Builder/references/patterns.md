+++
title = ".dockerignore pattern reference"
domain = "agent-skills"
topics = ["agent-skills", "context-engineering", "runbooks", "automation"]
difficulty = "intermediate"
progressive_tier = "Tier 4"
parent = "Agents.md"
children = []
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
# .dockerignore pattern reference

Annotated pattern tables used by `scripts/generate_dockerignore.py`. Use this file directly if you (the AI reading this) cannot execute code — follow the "Manual composition algorithm" at the bottom.

---

## 1. Universal (always include)

```dockerignore
# Version control
.git
.gitattributes
.github/

# Docker itself
Dockerfile*
docker-compose*.yml
.dockerignore

# Docs
README*
CHANGELOG*
LICENSE*
docs/

# Editors / IDE
.vscode/
.idea/
*.swp
*.swo

# OS cruft
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Secrets (defense in depth -- see caveat in SKILL.md)
.env
.env.*
*.pem
*.key
*.crt
*.pfx
*.p12
id_rsa*
id_ed25519*
secrets/
```

*Note: `.git` without a trailing slash covers both standard `.git/` directories and `.git` pointer files used in git worktrees and submodules.*

---

## 2. Python

Include this block if the project has `requirements*.txt`, `pyproject.toml`, `Pipfile`, `setup.py`/`setup.cfg`, `manage.py`, or `*.py` files.

```dockerignore
# Python
__pycache__/
*.py[cod]
*$py.class
.venv/
venv/
env/
ENV/
.mypy_cache/
.pytest_cache/
.ruff_cache/
.tox/
.coverage
.coverage.*
htmlcov/
dist/
build/
*.egg-info/
.ipynb_checkpoints/
```

---

## 3. Google Cloud

Include this block if the project has `app.yaml`, `cloudbuild.yaml`/`.yml`, `.gcloudignore`, `Procfile`, credential files matching `*service-account*.json` / `*-key.json`, `.tf` files with `provider "google"`, or requirements listing `google-cloud-*` packages.

```dockerignore
# Google Cloud
.gcloudignore
*service-account*.json
*-key.json
gcp-*.json
.terraform/
*.tfstate
*.tfstate.backup
.terraform.lock.hcl
```

---

## 4. Node.js / Frontend

Include this block if the project has `package.json`, `node_modules/`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, or `bun.lockb`.

```dockerignore
# Node.js / Frontend
node_modules/
.next/
.nuxt/
.cache/
coverage/
.npm/
yarn-error.log
pnpm-debug.log*
```

---

## 5. Alpine & Minimal Base Image Rationale

Alpine and minimal base images (`python:3.x-alpine`, `node:alpine`) are chosen specifically to minimize final container image sizes. A bloated **build context** (sent to the Docker daemon before the build starts) undermines these performance gains by adding context hashing & upload latency to every single build invocation. Excluding local virtual environments (`.venv/`), caches (`__pycache__/`, `.next/`), dependency folders (`node_modules/`), and VCS metadata (`.git`) ensures builds start instantly.

---

## Manual Composition Algorithm (for AIs without code execution)

If you are an AI that cannot execute Python scripts (text-only prompt interface):

1. Start with the **Universal** block.
2. Inspect the project tree / file list provided by the user.
3. If Python files or config files (`requirements.txt`, `pyproject.toml`, `.py`) exist → append the **Python** block.
4. If GCP files (`cloudbuild.yaml`, `app.yaml`, `.tf` with GCP provider) exist → append the **Google Cloud** block.
5. If Node / frontend files (`package.json`, `node_modules`, lockfiles) exist → append the **Node.js / Frontend** block.
6. Deduplicate lines.
7. If an existing `.dockerignore` exists, present a diff or ask whether to merge/replace.
8. Include the security caveat regarding tracked credentials.
