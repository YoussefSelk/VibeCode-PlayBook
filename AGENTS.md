# ResuMateAI Agent Workflow

This project uses a coordinated multi-agent system designed for production-grade development.

## Team Roles

- `prompt-engineer`  
  Converts vague requests into precise, execution-ready prompts and orchestrates agent workflows.

- `db`  
  Owns schema design, migrations, data integrity, indexing, and persistence-layer compatibility.

- `backend`  
  Owns APIs, controllers, services, validation, authentication, and business logic.

- `frontend`  
  Owns UI, components, UX behavior, responsiveness, accessibility, and client-side state.

- `tester`  
  Validates real end-to-end behavior across DB → Backend → API → Frontend → User.

- `reviewer`  
  Performs final review for correctness, regressions, architecture, security, and performance risks.

---

## Core Principles

- Passing tests ≠ working system
- Each layer must be correct **and** correctly connected
- Always validate real behavior, not assumptions
- Prefer simple, explicit, maintainable solutions
- Adapt to the repository's actual stack instead of forcing one

---

## Default Workflow

### 1. Ambiguous / Rough Requests

→ Always start with `prompt-engineer`

Goal:

- clarify intent
- remove ambiguity
- produce execution-ready prompt(s)
- define agent sequence if needed

---

### 2. Implementation

Route work strictly by ownership:

- Schema / migrations / queries → `db`
- API / business logic → `backend`
- UI / UX / client logic → `frontend`

Rules:

- Do NOT mix responsibilities
- Avoid multiple agents editing same files unless required
- If contracts change → update both sides
- Do not force frameworks, folder structures, or libraries the repo does not already use

Parallel execution:

- Only when layers are independent (e.g. UI + backend endpoints already defined)

---

### 3. Validation (MANDATORY)

→ Always use `tester`

Scope:

- DB correctness
- API contracts
- frontend integration
- runtime behavior

Important:

- Do NOT rely only on unit tests
- Validate real data flow:
  DB → Backend → API → Frontend

---

### 4. Final Review (MANDATORY)

→ Always use `reviewer`

Focus:

- regressions
- security issues
- performance risks
- architectural drift
- missing test coverage

---

## Coordination Rules

- Controllers must stay thin
- Business logic belongs in services (backend)
- UI must not contain business logic
- Database must enforce integrity (not only code)

- If a change impacts:
  - API shape
  - DB schema
  - frontend expectations

→ Validate BOTH sides of the boundary

- If behavior is suspicious:
  → trust runtime validation (`tester`) over tests

---

## Recommended Agent Sequences

### Bug Fix (Full Stack)

prompt-engineer → db/backend/frontend → tester → reviewer

---

### Backend Feature

prompt-engineer → backend → tester → reviewer

---

### Schema / Migration

prompt-engineer → db → backend (if needed) → tester → reviewer

---

### Frontend Feature

prompt-engineer → frontend → tester → reviewer

---

### Cross-Layer Feature (IMPORTANT)

prompt-engineer → db → backend → frontend → tester → reviewer

---

## Contract Awareness (CRITICAL)

Always verify:

- Field naming consistency  
  (userId vs user_id)

- Data shape consistency  
  (DB → API → frontend)

- Type consistency  
  (nullability, arrays, objects)

---

## Definition of Done (VERY IMPORTANT)

A task is ONLY complete when:

- Implementation is correct
- End-to-end behavior is validated (`tester`)
- No major risks found (`reviewer`)

---

## Prompting Guidance

Every task must clearly define:

- GOAL → what needs to be done
- SCOPE → which layer(s)
- TASKS → what to inspect / implement
- VALIDATION → how success is verified
- OUTPUT → what the agent must return

---

## Failure Detection Mindset

Always assume:

- contracts may be broken
- data may be inconsistent
- UI may hide errors
- tests may be incomplete

Your job is to prove the system works — not assume it.

---

## Key Rule

If the user does not specify:
→ Start with `prompt-engineer`

Never execute vague requests directly.

---

## Repo Workflow Aids

Use these project files to keep sessions consistent:

- `README.md` for the quick-start workflow
- `docs/VIBE_CODING_PLAYBOOK.md` for the team operating model
- `docs/PROMPT_TEMPLATES.md` for reusable prompt patterns
- `docs/SESSION_BRIEF_TEMPLATE.md` for stronger starting context
- `docs/WORKFLOWS.md` for execution recipes
