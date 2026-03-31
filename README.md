
# VibeCoders-PlayBook

This repository is prepared for a Codex-first, multi-agent development workflow.

## Current Setup

Project-local Codex configuration:
- `.codex/config.toml`

Specialized agents:
- `.codex/agents/prompt-engineer.toml`
- `.codex/agents/db.toml`
- `.codex/agents/backend.toml`
- `.codex/agents/frontend.toml`
- `.codex/agents/tester.toml`
- `.codex/agents/reviewer.toml`

Team workflow rules:
- `AGENTS.md`

Vibe coding docs:
- `docs/VIBE_CODING_PLAYBOOK.md`
- `docs/PROMPT_TEMPLATES.md`
- `docs/SESSION_BRIEF_TEMPLATE.md`
- `docs/WORKFLOWS.md`

Prompt starters:
- `prompts/full-stack-bug.md`
- `prompts/full-feature.md`
- `prompts/runtime-debug.md`

Collaboration files:
- `CONTRIBUTING.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/ISSUE_TEMPLATE/`

## Recommended Workflow

1. Start with a rough request or fill out `docs/SESSION_BRIEF_TEMPLATE.md`.
2. Ask `prompt-engineer` to convert it into a clean execution prompt.
3. Let the implementation agents handle their owned layers:
   - `db`
   - `backend`
   - `frontend`
4. Ask `tester` to verify the full flow end to end.
5. Ask `reviewer` for the final regression and risk pass.

## Good Prompt Patterns

Cross-stack bug:

```text
Have prompt-engineer rewrite this into a strong execution prompt:
"Profile save is still broken. Check db, backend, and frontend and make sure it really works."
Then let the right agents handle their parts, ask tester to verify the full flow from database to UI, and ask reviewer to check for regressions.
```

Feature work:

```text
Have prompt-engineer turn this into a multi-agent task:
"Build resume import with backend validation, DB support, and frontend upload UI."
Then run db/backend/frontend as needed, tester for end-to-end validation, and reviewer for final review.
```

Backend-only:

```text
Ask prompt-engineer to rewrite this for backend:
"Add a secure endpoint for updating the resume title and validate ownership."
Then have backend implement it, tester verify runtime behavior, and reviewer inspect risks.
```

## Goal

The setup is designed so the project behaves more like a small dev team than a single generic assistant:
- cleaner prompts
- clearer ownership
- stronger end-to-end validation
- better final review before calling work done

## Repo Identity

This repo is now set up as a starter workspace for vibe coders:
- fast to start
- structured enough to scale
- optimized for rough ideas becoming real implementation
- built around multi-agent collaboration instead of one-shot prompting

It is intentionally stack-agnostic:
- the agents coordinate on ownership and validation
- they adapt to the framework and layout you actually use
- they do not assume a specific folder structure unless the repo already does
