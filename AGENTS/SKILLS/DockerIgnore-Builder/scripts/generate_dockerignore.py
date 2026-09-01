#!/usr/bin/env python3
"""
generate_dockerignore.py

Scans a project directory and generates a tailored .dockerignore file.
Standard library only -- no dependencies, no network access required.
Works the same whether invoked by a human, Claude, Gemma, Copilot, Codex,
Antigravity, or any other tool that can run a Python script.

Usage:
    python3 generate_dockerignore.py [project_dir] [--merge] [--dry-run] [--output PATH] [--json]
"""

import argparse
import json
import os
import re
import sys

MAX_SCAN_DEPTH = 3  # directory levels below project_dir to search for indicator files

UNIVERSAL = """# Version control
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

# Secrets (defense in depth -- not a substitute for real secret management)
.env
.env.*
*.pem
*.key
*.crt
*.pfx
*.p12
id_rsa*
id_ed25519*
secrets/"""

PYTHON_BLOCK = """# Python
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
.ipynb_checkpoints/"""

GCP_BLOCK = """# Google Cloud
.gcloudignore
*service-account*.json
*-key.json
gcp-*.json
.terraform/
*.tfstate
*.tfstate.backup
.terraform.lock.hcl"""

NODE_BLOCK = """# Node.js / Frontend
node_modules/
.next/
.nuxt/
.cache/
coverage/
.npm/
yarn-error.log
pnpm-debug.log*"""

PYTHON_INDICATOR_NAMES = {
    "requirements.txt", "pyproject.toml", "Pipfile", "Pipfile.lock",
    "setup.py", "setup.cfg", "manage.py",
}
PYTHON_INDICATOR_PREFIXES = ("requirements",)

GCP_INDICATOR_NAMES = {
    "app.yaml", "cloudbuild.yaml", "cloudbuild.yml", ".gcloudignore", "Procfile",
}
GCP_KEY_FILE_RE = re.compile(r"(service-account.*\.json$|-key\.json$|^gcp-.*\.json$)", re.IGNORECASE)
GCP_TF_PROVIDER_RE = re.compile(r'provider\s+"google"')
GCP_PACKAGE_RE = re.compile(r"google-cloud-", re.IGNORECASE)

NODE_INDICATOR_NAMES = {
    "package.json", "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb"
}


def walk_limited(root, max_depth):
    root = os.path.abspath(root)
    base_depth = root.rstrip(os.sep).count(os.sep)
    for dirpath, dirnames, filenames in os.walk(root):
        depth = dirpath.rstrip(os.sep).count(os.sep) - base_depth
        if depth >= max_depth:
            dirnames[:] = []  # don't descend further
        # skip huge/irrelevant dirs early
        dirnames[:] = [d for d in dirnames if d not in {
            ".git", "node_modules", ".venv", "venv", "env", "__pycache__", ".terraform"
        }]
        yield dirpath, dirnames, filenames


def rel_path(path, project_dir):
    rel = os.path.relpath(path, project_dir)
    return f"./{rel}" if not rel.startswith(".") else rel


def detect_python(project_dir):
    reasons = []
    for dirpath, _, filenames in walk_limited(project_dir, MAX_SCAN_DEPTH):
        for f in filenames:
            rp = rel_path(os.path.join(dirpath, f), project_dir)
            if f in PYTHON_INDICATOR_NAMES:
                reasons.append(f"found {f} at {rp}")
                break
            if any(f.startswith(p) and f.endswith(".txt") for p in PYTHON_INDICATOR_PREFIXES):
                reasons.append(f"found {f} at {rp}")
                break
            if f.endswith(".py"):
                reasons.append(f"found Python source ({f}) at {rp}")
                break
        if reasons:
            break
    return (len(reasons) > 0), reasons


def detect_gcp(project_dir):
    reasons = []
    seen_reasons = set()

    def add_reason(r):
        if r not in seen_reasons:
            seen_reasons.add(r)
            reasons.append(r)

    # Check dependency definition files for google-cloud packages
    dep_files = ["requirements.txt", "pyproject.toml", "Pipfile", "setup.py"]
    for dep_file in dep_files:
        dep_path = os.path.join(project_dir, dep_file)
        if os.path.isfile(dep_path):
            try:
                with open(dep_path, "r", errors="ignore") as fh:
                    content = fh.read()
                    if GCP_PACKAGE_RE.search(content):
                        add_reason(f"google-cloud package referenced in {dep_file}")
            except OSError:
                pass

    for dirpath, _, filenames in walk_limited(project_dir, MAX_SCAN_DEPTH):
        for f in filenames:
            rp = rel_path(os.path.join(dirpath, f), project_dir)
            if f in GCP_INDICATOR_NAMES:
                add_reason(f"found {f} at {rp}")
            if GCP_KEY_FILE_RE.search(f):
                add_reason(f"found credential-shaped file ({f}) at {rp}")
            if f.endswith(".tf"):
                try:
                    with open(os.path.join(dirpath, f), "r", errors="ignore") as fh:
                        if GCP_TF_PROVIDER_RE.search(fh.read()):
                            add_reason(f'found provider "google" in {rp}')
                except OSError:
                    pass

    return (len(reasons) > 0), reasons


def detect_node(project_dir):
    reasons = []
    for dirpath, dirnames, filenames in walk_limited(project_dir, MAX_SCAN_DEPTH):
        if "node_modules" in dirnames:
            rp = rel_path(os.path.join(dirpath, "node_modules"), project_dir)
            reasons.append(f"found node_modules directory at {rp}")
            break
        for f in filenames:
            if f in NODE_INDICATOR_NAMES:
                rp = rel_path(os.path.join(dirpath, f), project_dir)
                reasons.append(f"found {f} at {rp}")
                break
        if reasons:
            break
    return (len(reasons) > 0), reasons


def build_content(include_python, include_gcp, include_node):
    blocks = [UNIVERSAL]
    if include_python:
        blocks.append(PYTHON_BLOCK)
    if include_gcp:
        blocks.append(GCP_BLOCK)
    if include_node:
        blocks.append(NODE_BLOCK)
    return "\n\n".join(blocks) + "\n"


def merge_with_existing(new_content, existing_path):
    """Keep custom lines from an existing .dockerignore that aren't already covered."""
    with open(existing_path, "r", errors="ignore") as fh:
        existing_lines = [ln.rstrip("\n") for ln in fh]

    new_lines = set(ln.strip() for ln in new_content.splitlines() if ln.strip() and not ln.strip().startswith("#"))
    custom = [
        ln for ln in existing_lines
        if ln.strip() and not ln.strip().startswith("#") and ln.strip() not in new_lines
    ]
    if not custom:
        return new_content
    return new_content.rstrip("\n") + "\n\n# --- Preserved from existing .dockerignore ---\n" + "\n".join(custom) + "\n"


def main():
    parser = argparse.ArgumentParser(description="Generate a tailored .dockerignore file.")
    parser.add_argument("project_dir", nargs="?", default=".", help="Project root to scan (default: current directory)")
    parser.add_argument("--merge", action="store_true", help="Preserve custom lines from an existing .dockerignore")
    parser.add_argument("--dry-run", action="store_true", help="Print result instead of writing a file")
    parser.add_argument("--output", default=None, help="Output path (default: <project_dir>/.dockerignore)")
    parser.add_argument("--json", action="store_true", help="Output results in JSON format (ideal for local LLM function calling)")
    args = parser.parse_args()

    project_dir = os.path.abspath(args.project_dir)
    if not os.path.isdir(project_dir):
        msg = f"Error: {project_dir} is not a directory"
        if args.json:
            print(json.dumps({"error": msg}))
        else:
            print(msg, file=sys.stderr)
        sys.exit(1)

    output_path = args.output or os.path.join(project_dir, ".dockerignore")

    is_python, py_reasons = detect_python(project_dir)
    is_gcp, gcp_reasons = detect_gcp(project_dir)
    is_node, node_reasons = detect_node(project_dir)

    content = build_content(is_python, is_gcp, is_node)

    if os.path.isfile(output_path) and args.merge:
        content = merge_with_existing(content, output_path)

    if args.json:
        result = {
            "project_dir": project_dir,
            "output_path": output_path,
            "dry_run": args.dry_run,
            "merge": args.merge,
            "detected_stacks": {
                "universal": {"detected": True, "reasons": ["Always applied"]},
                "python": {"detected": is_python, "reasons": py_reasons},
                "gcp": {"detected": is_gcp, "reasons": gcp_reasons},
                "node": {"detected": is_node, "reasons": node_reasons},
            },
            "content": content
        }
        print(json.dumps(result, indent=2))
        return

    # Standard human/agent text summary
    print("Detection summary:")
    print(f"  Python:       {'YES - ' + py_reasons[0] if is_python else 'no'}")
    if is_gcp:
        print("  Google Cloud: YES")
        for r in gcp_reasons:
            print(f"                - {r}")
    else:
        print("  Google Cloud: no")
    if is_node:
        print(f"  Node/Frontend: YES - {node_reasons[0]}")
    else:
        print("  Node/Frontend: no")
    print()

    if args.dry_run:
        print(f"--- Would write to {output_path} ---")
        print(content)
    else:
        if os.path.isfile(output_path) and not args.merge:
            print(f"Note: overwriting existing {output_path} (use --merge to preserve custom entries)")
        with open(output_path, "w") as fh:
            fh.write(content)
        print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
