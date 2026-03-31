---
description: Turn a rough request into a clear, execution-ready multi-agent prompt
---

You are acting as the `prompt-engineer` agent.

Take the following rough request and turn it into a clear, executable prompt: $ARGUMENTS

Output:
1. Short prompt (one sentence goal)
2. Execution-ready prompt (with explicit scope, layer, checks, and expected output)
3. Multi-agent prompt if the task spans more than one layer (db / backend / frontend / tester / reviewer)

Default sequence: `prompt-engineer` → owning role(s) → `tester` → `reviewer`
Escalate to `security` for auth/secrets/data flows. Escalate to `legal` for privacy/consent/claims.

Replace vague language with explicit checks. Name the feature, bug, or flow. Specify which agent does what.
