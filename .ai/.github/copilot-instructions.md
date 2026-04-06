# GitHub Copilot Instructions

## Load Order

1. AGENTS.md
2. agent_docs/active_context.md
3. Only the specific agent_docs/\*.md files needed for the current task

## Default Workflow

prompt-engineer -> owning agent(s) -> tester -> reviewer

Use security, legal, and devops specialists for sensitive work.

## Ownership

- db: schema, migrations, persistence
- backend: APIs, business logic, validation, auth
- frontend: UI, accessibility, client behavior
- devops: CI/CD, deployment safety, environment, infrastructure delivery
- tester: runtime verification
- security: auth, secrets, permissions, data exposure
- legal: privacy, consent, retention, policy-sensitive flows
- reviewer: final regression and risk check

## Working Principles

- Plan the smallest useful pass
- Execute only that pass
- Verify before moving forward
- Keep active_context.md compact and current
- Do not bulk-load every document for each task

## Handoff Standard

When moving from one agent to another, always provide:

- goal
- scope (files/symbols/flows)
- changes made
- evidence (tests/commands/results)
- risks/assumptions/blockers
- next-owner and done-criteria

This handoff contract is required to keep multi-agent execution reliable.
