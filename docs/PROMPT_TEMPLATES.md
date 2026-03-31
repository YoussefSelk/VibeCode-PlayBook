# Prompt Templates

Use these as copy-paste starters.

## 1. Rough Request Cleanup

```text
Have prompt-engineer turn this into a strong execution prompt for the right agents:
"[paste rough request here]"
```

## 2. Cross-Stack Bug

```text
Have prompt-engineer rewrite this into a clear multi-agent task:
"[describe the bug]"

Then:
- let db inspect schema/query/data assumptions if needed
- let backend inspect API, validation, and business logic
- let frontend inspect UI wiring and payload handling
- ask tester to verify the full flow from DB to backend to frontend
- ask reviewer to perform a final regression and risk review
```

## 3. Backend Feature

```text
Have prompt-engineer rewrite this for backend implementation:
"[describe the feature]"

Then have backend implement it, tester verify runtime behavior and edge cases, and reviewer inspect for regressions and missing coverage.
```

## 4. Frontend Feature

```text
Have prompt-engineer rewrite this for frontend implementation:
"[describe the UI feature]"

Then have frontend implement it, tester verify the real UI flow and API wiring, and reviewer inspect for regressions and maintainability risks.
```

## 5. Database Change

```text
Have prompt-engineer rewrite this for db work:
"[describe the schema/query/migration need]"

Then have db inspect schema design, constraints, indexes, and migration safety.
If contracts change, involve backend too.
Ask tester to verify the affected flow end to end and reviewer to inspect risks.
```

## 6. Full Feature Delivery

```text
Have prompt-engineer turn this into a clean multi-agent plan:
"[describe the feature]"

Use db/backend/frontend only where needed.
Keep ownership clear.
After implementation, ask tester to verify the feature end to end and ask reviewer for a final review focused on regressions, correctness, and missing tests.
```

## 7. Runtime Failure That Survives Tests

```text
Have prompt-engineer rewrite this into a debugging prompt:
"[describe the runtime failure]"

Do not stop at unit tests.
Trace the issue from database to backend to frontend and identify exactly where the chain breaks.
Ask tester to reproduce and validate the real failure, then ask reviewer to inspect the fix for risk.
```

## 8. PR Review

```text
Ask reviewer to review this change for bugs, regressions, security issues, architecture drift, and missing tests.
Prioritize findings over style comments.
```
