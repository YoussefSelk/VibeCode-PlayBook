# Claude Workflow Guide

This repository uses a role-based workflow for reliable multi-agent delivery.

## Startup Order

1. Read AGENTS.md.
2. Read agent_docs/active_context.md.
3. Read only the specific agent_docs file(s) needed for the task.

## Default Flow

prompt-engineer -> owning agent(s) -> tester -> reviewer

Use security and legal reviews when the task requires them.

## Ownership

- db: schema, migrations, data layer
- backend: APIs, validation, business logic, auth
- frontend: UI, client behavior, accessibility
- devops: CI/CD, deployment safety, environment, and infrastructure delivery
- tester: runtime validation
- security: auth, secrets, permissions, sensitive data
- legal: privacy, consent, retention, policy-sensitive flows
- reviewer: final regression and risk check

## Working Rules

- Plan the smallest useful pass.
- Execute only that pass.
- Verify before moving forward.
- Keep active_context.md compact and current.
- Do not bulk-load all docs for every task.

## Definition of Done

A task is done only when implementation is correct, runtime behavior is validated where relevant, cross-layer contracts are checked, and final risks are acceptable.
