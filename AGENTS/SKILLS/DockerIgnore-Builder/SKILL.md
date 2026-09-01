---
name: dockerignore-builder
description: Generate or update a tailored .dockerignore file for a project. Scans the project for Python, Google Cloud, and Node.js indicators, and applies universal build-context hygiene (git, OS, IDE, docs, CI, secrets). Ideal for local agents (Gemma, Claude, Copilot, Antigravity) running locally or offline. Trigger whenever the user asks to create, fix, or review a .dockerignore file, shrink Docker build context, or containerize Python/GCP/Node apps.
compatibility: Python 3.7+ standard library only. Zero third-party packages, zero network required. Works identically whether invoked by Claude, Gemma (local), Copilot, Codex, Antigravity, or a human directly from a terminal.
---

# dockerignore-builder

Builds a `.dockerignore` file tailored to a project by combining:
1. **Universal hygiene** — files that should basically never enter a Docker build context (VCS metadata `.git`, OS cruft, editor config, docs, CI config, secrets/keys).
2. **Python-specific patterns** — applied when Python source, `requirements*.txt`, `pyproject.toml`, or `setup.py` are present.
3. **Google Cloud-specific patterns** — applied when GCP deployment artifacts (Cloud Run, App Engine, `cloudbuild.yaml`, Terraform GCP provider, credentials) are detected.
4. **Node.js / Frontend patterns** — applied when `package.json`, `node_modules/`, or frontend lockfiles are detected.
5. **Alpine build-hygiene notes** — guidance specific to building onto minimal base images (like `python:*-alpine` or `node:*-alpine`), where bloated build context slows hashing & transfer.

---

## Guidance for Local Agents (e.g., Gemma 2 / Gemma 3)

If you are a local agent (such as Gemma running via Ollama, llama.cpp, vLLM, or Antigravity):

1. **Use `--json` mode for deterministic parsing**: When invoking the script, pass `--json` alongside `--dry-run` to receive machine-readable JSON stdout instead of freeform text logs.
2. **Standard Workflow**:
   - Step 1: Run `python3 scripts/generate_dockerignore.py <project_dir> --dry-run --json`
   - Step 2: Read `detected_stacks` to report detected project frameworks and reasons to the user.
   - Step 3: Present the proposed `.dockerignore` content to the user.
   - Step 4: If the user approves (or asks to apply), re-run without `--dry-run` (add `--merge` if a `.dockerignore` file already exists).

### Example 1-Shot Model Turn for Gemma

**User**: "Can you clean up my Docker build context and create a .dockerignore file?"

**Agent Action (Tool Call)**:
```bash
python3 scripts/generate_dockerignore.py . --dry-run --json
```

**Agent Response to User**:
> "I scanned your project directory and detected the following stacks:
> - **Python**: `requirements.txt` detected.
> - **Google Cloud**: `cloudbuild.yaml` and GCP Terraform configuration detected.
> 
> Below is the recommended `.dockerignore` tailored for your repository:
> ```dockerignore
> [insert content from JSON response]
> ```
> Would you like me to write this to `.dockerignore` now?"

---

## How to use the script

```bash
python3 scripts/generate_dockerignore.py [project_dir] [--merge] [--dry-run] [--output PATH] [--json]
```

- `project_dir` — path to the project root to scan (default: `.`).
- `--merge` — if a `.dockerignore` already exists, preserve custom entries user added.
- `--dry-run` — print result to stdout without writing file.
- `--output PATH` — write to a custom file path instead of `<project_dir>/.dockerignore`.
- `--json` — output results formatted as structured JSON for easy parsing by local agents (Gemma).

---

## What gets detected

| Category | Triggered by |
|---|---|
| Universal (Always applied) | `.git` (worktree-safe), `.github/`, editor/IDE dirs, OS files (`.DS_Store`, `Thumbs.db`), logs, secret key patterns (`.env*`, `*.pem`, `*.key`, `*.pfx`, `id_rsa*`, `id_ed25519*`), docs (`README*`, `LICENSE`, `docs/`) |
| Python | `requirements*.txt`, `pyproject.toml`, `Pipfile`, `setup.py`/`setup.cfg`, `manage.py`, or `*.py` files within top 3 directory levels |
| Google Cloud | `app.yaml`, `cloudbuild.yaml`/`.yml`, `.gcloudignore`, `Procfile`, credential files (`*service-account*.json`, `*-key.json`), Terraform `.tf` files with `provider "google"`, or `google-cloud-*` dependencies in `requirements.txt`/`pyproject.toml`/`Pipfile` |
| Node.js / Frontend | `package.json`, `node_modules/`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `bun.lockb` |

---

## Secrets & Security Note

A `.dockerignore` entry keeps files out of the **build context** (preventing accidental copying into images during `COPY . .`). However, `.dockerignore` **does not remove tracked secrets from git history or local disk**. If credential files exist in git, instruct the user to use secret managers or tools like `git filter-repo` / `BFG`.

---

## Files in this skill

- `scripts/generate_dockerignore.py` — detection & generation script (supports `--json`).
- `references/patterns.md` — full annotated pattern tables per category + manual composition rules for text-only LLMs.
