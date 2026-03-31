
# VibeCoders-PlayBook

This repo is a lean Codex multi-agent layer you can drop into a real project.

## Docs Site

This repo now includes a GitHub Pages-ready static guide in `docs/`.

- human-friendly entry page: `docs/index.html`
- machine-readable onboarding: `docs/llms.txt`
- expanded LLM guide: `docs/llms-full.txt`
- deploy workflow: `.github/workflows/deploy-pages.yml`

If you use GitHub Pages with GitHub Actions, pushes to `main` that change `docs/` will deploy the site automatically.

Purpose:
- better agent coordination
- less repeated context
- fewer wasted tokens
- stronger end-to-end validation

## What You Get

- `AGENTS.md`
  Main operating rules for the whole team.

- `.codex/agents/`
  Specialized agents:
  - `prompt-engineer`
  - `db`
  - `backend`
  - `frontend`
  - `tester`
  - `security`
  - `legal`
  - `reviewer`

- `agent_docs/`
  Progressive-disclosure context files.
  Only load what the current task needs.

## Quick Start

### 1. Install into your project

PowerShell:

```powershell
iex "& { $(irm https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.ps1) }"
```

PowerShell into a specific folder:

```powershell
iex "& { $(irm https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.ps1) } -Destination 'C:\path\to\your\project'"
```

Bash:

```bash
curl -fsSL https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.sh | bash
```

Bash into a specific folder:

```bash
curl -fsSL https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.sh | bash -s -- --destination /path/to/your/project
```

### 2. Fill the minimum context

After install, fill these files first:

- `agent_docs/project_brief.md`
- `agent_docs/tech_stack.md`
- `agent_docs/active_context.md`
- `agent_docs/verification.md`

Keep them short.
These files exist to reduce repeated prompting.

### 3. Start with `prompt-engineer`

Do not start with a vague implementation prompt.

Start with:

```text
Have prompt-engineer turn this into a clear execution prompt:
"[your rough request here]"
```

### 4. Let the owning agent implement

Use the right specialist:

- `db` for schema, migrations, persistence, data contracts
- `backend` for APIs, validation, business logic, auth
- `frontend` for UI, forms, client behavior, accessibility

### 5. Verify the real behavior

After implementation:
- use `tester` for runtime and integration validation
- use `security` for attack-surface or sensitive-data work
- use `legal` for privacy, consent, policy, or claim-sensitive work
- use `reviewer` for the final regression/risk pass

## Step-by-Step Usage Guide

### Step 1. Drop the playbook into a real repo

Use one of the install commands above.

By default:
- existing files are skipped
- only the core workflow files are added

Overwrite existing files:

PowerShell:

```powershell
iex "& { $(irm https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.ps1) } -Destination 'C:\path\to\your\project' -Force"
```

Bash:

```bash
curl -fsSL https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.sh | bash -s -- --destination /path/to/your/project --force
```

Overwrite and create backups first:

PowerShell:

```powershell
iex "& { $(irm https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.ps1) } -Destination 'C:\path\to\your\project' -Force -Backup"
```

Bash:

```bash
curl -fsSL https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.sh | bash -s -- --destination /path/to/your/project --force --backup
```

### Step 2. Add the durable project context

Fill `agent_docs/project_brief.md` with:
- what the product is
- who it is for
- core flows
- constraints
- quality bar

Fill `agent_docs/tech_stack.md` with:
- actual framework and libraries
- real commands
- env/setup notes
- architecture boundaries

Fill `agent_docs/verification.md` with:
- test commands
- manual validation steps
- high-risk areas

### Step 3. Keep `active_context.md` current

This is the most important day-to-day file.

Use `agent_docs/active_context.md` for:
- current goal
- active scope
- current task
- blockers
- next step

Do not turn it into a diary.
Keep it compact and current.

### Step 4. Use the right load order

Agents should load context in this order:

1. `AGENTS.md`
2. `agent_docs/active_context.md`
3. only the one or two specific `agent_docs/*.md` files needed for the task

This is how you reduce token waste.

### Step 5. Always shape rough requests first

Example:

```text
Have prompt-engineer rewrite this into a clear multi-agent task:
"Profile save is broken and I want to make sure it actually works."
```

What `prompt-engineer` is for:
- remove ambiguity
- assign the right owners
- add missing validation steps
- avoid low-signal prompts

### Step 6. Route work by ownership

Use these rules:

- `db`
  - schema changes
  - migrations
  - persistence logic
  - data contract issues

- `backend`
  - endpoints
  - service logic
  - validation
  - auth
  - integrations

- `frontend`
  - components
  - forms
  - state behavior
  - request/response handling
  - accessibility

### Step 7. Run the right validation layer

Use `tester` when:
- the task crosses layers
- the bug survives tests
- you need real runtime proof

Example:

```text
Ask tester to verify the full flow from database to backend to frontend.
Do not stop at unit tests. Reproduce the behavior and identify any contract mismatch.
```

Use `security` when:
- login/auth/session code changed
- permissions or roles changed
- uploads are involved
- secrets or sensitive data are involved
- a feature changes trust boundaries

Example:

```text
Ask security to review this flow for authorization gaps, secret exposure,
unsafe input handling, and sensitive data leakage.
```

Use `legal` when:
- privacy or consent changed
- analytics/cookies/tracking changed
- retention or deletion behavior changed
- marketing or product claims are risky
- AI output disclosures or policy-sensitive flows are involved

Example:

```text
Ask legal to review this feature for privacy, consent, retention,
disclosure, and policy-sensitive product risk. Flag anything that should go to counsel.
```

### Step 8. Finish with `reviewer`

Use `reviewer` as the final serious checkpoint.

Example:

```text
Ask reviewer to review the changed work for regressions, security risks,
architecture drift, performance concerns, and missing test coverage.
```

### Step 9. Use the right workflow for the task

Normal feature:

`prompt-engineer -> implementation agent(s) -> tester -> reviewer`

Security-sensitive feature:

`prompt-engineer -> implementation agent(s) -> tester -> security -> reviewer`

Legal/compliance-sensitive feature:

`prompt-engineer -> implementation agent(s) -> tester -> legal -> reviewer`

Very sensitive feature:

`prompt-engineer -> implementation agent(s) -> tester -> security -> legal -> reviewer`

### Step 10. Update context after each meaningful pass

After finishing work, update:
- `agent_docs/active_context.md`
- `agent_docs/decisions.md` if a durable decision was made
- `agent_docs/verification.md` if new checks became important

This keeps the next session fast and avoids re-explaining everything.

## Agent Roles

- `prompt-engineer`
  Turns rough asks into clear execution prompts and chooses the agent sequence.

- `db`
  Owns schema, migrations, queries, and persistence-layer contracts.

- `backend`
  Owns APIs, business logic, validation, auth, and backend contracts.

- `frontend`
  Owns UI, client behavior, accessibility, and frontend-side API integration.

- `tester`
  Verifies the real runtime flow across layers.

- `security`
  Reviews attack surface, auth, permissions, secrets, and data exposure.

- `legal`
  Reviews privacy, consent, retention, policy-sensitive flows, and risky claims.

- `reviewer`
  Performs the final regression and risk review.

## Key Idea

Do not dump the whole repo context into every task.

Use short, durable docs and load only the files needed for the current pass.

## Install Notes

The installer adds only the core files:
- `AGENTS.md`
- `.codex/config.toml`
- `.codex/agents/*`
- `agent_docs/*`

Behavior:
- existing files are skipped by default
- `-Force` or `--force` overwrites existing files
- `-Backup` or `--backup` creates timestamped backups before overwrite
- PowerShell uses `Invoke-WebRequest`
- Bash uses `curl`, or `wget` if `curl` is unavailable

## License

MIT. See `LICENSE`.
