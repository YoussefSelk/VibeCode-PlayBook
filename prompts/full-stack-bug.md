# Full-Stack Bug Prompt

```text
Have prompt-engineer rewrite this into a strong multi-agent debugging task:
"[describe the bug here]"

Then:
- route schema or query issues to db
- route API and business logic issues to backend
- route UI and client wiring issues to frontend
- ask tester to verify the full real flow from database to backend to frontend
- ask reviewer to check the final fix for regressions, architecture drift, security issues, and missing coverage
```
