# Project Brief

## Product

- name:
- VibeCoders Playbook
- one-line description:
- a lightweight multi-agent workflow layer that can be installed into another repo to improve coordination, context handling, and validation
- primary users:
- developers using Codex, GitHub Copilot, Claude, or similar coding assistants
- teams wanting clearer ownership across db, backend, frontend, testing, security, and review
- LLM agents that need a compact operating model for a repo

## Core Flows

- flow 1:
- install the playbook into a real project with the scripts in `scripts/`
- flow 2:
- fill the durable context files in `agent_docs/`
- flow 3:
- route work through `prompt-engineer`, the owning agent, validation, and final review

## Constraints

- business constraints:
- keep the workflow simple enough to drop into existing repos quickly
- technical constraints:
- avoid forcing frameworks or repo structures that do not already exist
- prefer low-maintenance static documentation and lightweight scripts
- compliance/privacy:
- the playbook can touch privacy-sensitive or policy-sensitive product work, so legal review paths must stay explicit
- non-goals:
- not a full project scaffolder
- not a replacement for application architecture or product-specific documentation

## Quality Bar

- performance:
- docs and install flows should stay lightweight and fast to load
- security:
- risk escalation to `security` must stay clear for auth, secrets, uploads, and sensitive data flows
- accessibility:
- onboarding materials should be easy to scan for humans and readable for agents
- testing expectations:
- workflow changes should be validated through the real runtime path when relevant, not only by inspection

## Notes For Agents

- repo-specific conventions:
- always load `AGENTS.md` first, then `agent_docs/active_context.md`, then only the specific docs needed
- things to avoid:
- bulk-loading all context files
- restating the whole repo in every prompt
- important assumptions:
- this repo is documentation- and workflow-heavy, so clarity and consistency matter as much as code changes
