# Runtime Debug Prompt

```text
Have prompt-engineer rewrite this into a debugging prompt:
"[describe the runtime failure here]"

Do not stop at unit tests.
Trace the issue from database to backend to frontend and identify exactly where the chain breaks.
Ask tester to reproduce and validate the real failure, then ask reviewer to inspect the fix for risk.
```
