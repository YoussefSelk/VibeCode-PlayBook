# Workflow Recipes

These are practical multi-agent recipes for common development work.

## Full-Stack Bug

Goal:
- find the real failure
- fix the right layer
- verify the system works end to end

Sequence:
- `prompt-engineer`
- `db` / `backend` / `frontend` as needed
- `tester`
- `reviewer`

Starter prompt:

```text
Have prompt-engineer rewrite this into a strong multi-agent debugging task:
"[describe the bug]"

Then route the work to the correct agents, ask tester to verify the real flow from DB to UI, and ask reviewer to check the final result for regressions and risk.
```

## Backend Feature

Sequence:
- `prompt-engineer`
- `backend`
- `tester`
- `reviewer`

Starter prompt:

```text
Have prompt-engineer rewrite this for backend implementation:
"[describe the feature]"

Then have backend implement it, tester verify runtime behavior and edge cases, and reviewer inspect for regressions and missing coverage.
```

## Database Change

Sequence:
- `prompt-engineer`
- `db`
- `backend` if contracts changed
- `tester`
- `reviewer`

Starter prompt:

```text
Have prompt-engineer rewrite this for db work:
"[describe the schema or query need]"

Then have db handle the change, involve backend if contracts are affected, ask tester to verify the real flow, and ask reviewer to inspect risk.
```

## UI Feature

Sequence:
- `prompt-engineer`
- `frontend`
- `tester`
- `reviewer`

Starter prompt:

```text
Have prompt-engineer rewrite this for frontend implementation:
"[describe the UI task]"

Then have frontend implement it, tester verify the real behavior and API wiring, and reviewer inspect risks and maintainability.
```

## Runtime Issue That Passes Tests

Sequence:
- `prompt-engineer`
- relevant implementation agents
- `tester`
- `reviewer`

Starter prompt:

```text
Have prompt-engineer rewrite this into a runtime-debugging task:
"[describe the issue]"

Do not stop at unit tests.
Trace the issue across DB, backend, and frontend where relevant.
Ask tester to reproduce the real failure and reviewer to inspect the final fix.
```
