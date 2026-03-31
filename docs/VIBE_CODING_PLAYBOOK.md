# Vibe Coding Playbook

This project is set up for fast, collaborative Codex-driven development.

## What "Vibe Coding" Means Here

The goal is fast iteration without losing structure.
That means:
- rough ideas are welcome
- prompts can start messy
- implementation can move quickly
- validation and review still happen before we trust the result

The workflow is optimized for momentum with guardrails.

## Team Workflow

### 1. Shape the request

Use `prompt-engineer` when your request is:
- vague
- emotional
- incomplete
- cross-functional
- hard to route

Its job is to convert rough instructions into clean execution prompts for the right agents.

### 2. Build with clear ownership

Use the implementation agents based on ownership:
- `db`: schema, migrations, constraints, indexes, query safety
- `backend`: APIs, controllers, services, validation, business logic
- `frontend`: UI, forms, component structure, state wiring, accessibility

Use parallel work only when the write scope is clearly separate.

### 3. Verify the real system

Use `tester` after implementation.

`tester` should not stop at "tests pass".
It should verify:
- data shape
- request/response contracts
- persistence behavior
- frontend wiring
- edge cases
- runtime failures
- integration mismatches

### 4. Review before trusting the result

Use `reviewer` after `tester`.

`reviewer` focuses on:
- bugs
- regressions
- missing tests
- architecture drift
- security risks
- hidden coupling

## Suggested Execution Flows

### Bug fix across the stack

`prompt-engineer` -> `db` / `backend` / `frontend` -> `tester` -> `reviewer`

### UI feature

`prompt-engineer` -> `frontend` -> `tester` -> `reviewer`

### Backend/API feature

`prompt-engineer` -> `backend` -> `tester` -> `reviewer`

### Schema or migration work

`prompt-engineer` -> `db` -> `backend` if contracts changed -> `tester` -> `reviewer`

### High-risk integration issue

`prompt-engineer` -> `db` + `backend` + `frontend` where needed -> `tester` with explicit end-to-end validation -> `reviewer`

## How to Write Better Requests

Include these when possible:
- what is broken or being built
- where the issue appears
- what the expected behavior is
- what is happening instead
- any constraints
- what "done" means

Even if you do not include them, the workflow can still start with `prompt-engineer`.

## Definition of Done

Work is not done just because:
- code compiles
- lint passes
- unit tests pass

Work is done when:
- the right layer changes were made
- the feature or fix behaves correctly
- the wiring between layers holds up
- the tester verified the real flow
- the reviewer checked for regressions and risk
