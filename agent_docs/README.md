# Agent Docs

This folder exists to reduce token waste.

Rule:
- do not load everything by default
- start with `AGENTS.md`
- only open the specific file needed for the current task

Suggested load order:
1. `AGENTS.md`
2. `agent_docs/active_context.md`
3. one or more targeted files below only if relevant

Files:
- `project_brief.md`: product, users, constraints, and high-level goals
- `tech_stack.md`: actual stack, commands, env, and architecture notes
- `active_context.md`: current focus, current task, blockers, and next step
- `verification.md`: how to validate changes in this repo
- `decisions.md`: important architectural or product decisions worth remembering

Keep these files short and current.
Long stale docs create token burn and bad decisions.
