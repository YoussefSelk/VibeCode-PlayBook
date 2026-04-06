# VibeCoders Playbook Agent Workflow

This repo is designed to improve agent coordination without wasting context.

## Load Order

Always load context in this order:

1. `AGENTS.md`
2. `agent_docs/active_context.md`
3. Only the specific `agent_docs/*.md` file needed for the task

Do not bulk-load every doc.

## Team Roles

- `prompt-engineer`
  Turns rough asks into clear execution prompts and chooses the right agent sequence.

- `db`
  Owns schema, migrations, queries, and persistence-layer contracts.

- `backend`
  Owns APIs, business logic, validation, auth, and backend contracts.

- `frontend`
  Owns UI, client behavior, accessibility, and frontend-side API integration.

- `devops`
  Owns CI/CD pipelines, deployment safety, infrastructure configuration, and runtime operability checks.

- `tester`
  Verifies the real runtime flow across layers.

- `security`
  Performs a paranoid security review for auth, permissions, secrets, input handling, and sensitive data exposure.

- `legal`
  Performs a legal/compliance risk review for privacy, consent, policy-sensitive flows, retention, and risky product claims.

- `reviewer`
  Performs the final regression and risk review.

## Default Flow

`prompt-engineer` -> owning agent(s) -> `tester` -> `reviewer`

Use this unless the task is truly single-layer and low-risk.

For security-sensitive work:

`prompt-engineer` -> owning agent(s) -> `tester` -> `security` -> `reviewer`

For legal/compliance-sensitive work:

`prompt-engineer` -> owning agent(s) -> `tester` -> `legal` -> `reviewer`

For deployment or infra-sensitive work:

`prompt-engineer` -> owning agent(s) -> `tester` -> `devops` -> `reviewer`

## Ownership Rules

- `db` for schema or persistence changes
- `backend` for API or business-logic changes
- `frontend` for UI or client-state changes
- `devops` for CI/CD, deployment, environment, and infrastructure delivery changes
- `tester` after implementation
- `security` for auth, secrets, access control, uploads, risky integrations, or sensitive data flows
- `legal` for privacy, consent, analytics, retention, AI disclosures, policy-sensitive copy, or regulated/sensitive flows
- `reviewer` before calling work done

If a change affects contracts between layers, verify both sides.

## Token Efficiency Rules

- Prefer short durable docs over long repeated prompts.
- Keep `agent_docs/active_context.md` current and compact.
- Record durable project facts in `agent_docs/project_brief.md`.
- Record stack and commands in `agent_docs/tech_stack.md`.
- Record real verification steps in `agent_docs/verification.md`.
- Record important decisions in `agent_docs/decisions.md`.
- Do not restate the whole project in every prompt.
- Do not force frameworks or folder structures the repo does not already use.

## Plan -> Execute -> Verify

For any meaningful task:

1. Plan the smallest useful pass
2. Execute only that pass
3. Verify before moving forward

## Inter-Agent Handoff Contract

To make agents collaborate reliably, each handoff must include:

- `goal`: what the next agent must achieve
- `scope`: exact files/symbols/flows in scope
- `changes`: what was changed (or investigated) so far
- `evidence`: commands/tests/results that support the current state
- `risks`: known risks, assumptions, and open questions
- `next-owner`: exact next agent role and why
- `done-criteria`: objective checks required before final sign-off

Handoff quality rules:

- Never hand off with vague text like "check this".
- Always include reproducible validation steps.
- If blocked, explicitly state blocker and smallest unblock path.
- If contracts changed, handoff must call out impacted layers.

## Definition of Done

A task is only done when:

- the owning layer change is correct
- the runtime behavior is validated when relevant
- contract mismatches are checked
- reviewer-level risks are acceptable

## Key Rule

If the task is vague, start with `prompt-engineer`.
