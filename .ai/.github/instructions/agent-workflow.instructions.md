---
applyTo: "**"
---

Follow AGENTS.md as the source of truth.

Required load order:
1. AGENTS.md
2. agent_docs/active_context.md
3. only specific agent_docs/*.md needed for the task

Default execution chain:
prompt-engineer -> owner(s) -> tester -> reviewer

Escalation:
- Include security for auth, permissions, secrets, uploads, risky integrations, or sensitive data.
- Include legal for privacy, consent, analytics, retention, AI disclosures, or policy-sensitive copy.

Definition of done:
- owning layer change is correct
- runtime behavior validated when relevant
- cross-layer contract mismatches checked
- reviewer-level risks acceptable
