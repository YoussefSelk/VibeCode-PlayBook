
# VibeCoders-PlayBook

This repo is a lean Codex multi-agent layer you can drop into a real project.

Purpose:
- better agent coordination
- less repeated context
- fewer wasted tokens
- stronger end-to-end validation

## What Matters

- `AGENTS.md`
  Main operating rules for the whole team.

- `.codex/agents/`
  Specialized agents:
  - `prompt-engineer`
  - `db`
  - `backend`
  - `frontend`
  - `tester`
  - `reviewer`

- `agent_docs/`
  Progressive-disclosure context files.
  Only load what the current task needs.

## Recommended Use

1. Put this into your real project.
2. Fill in:
   - `agent_docs/project_brief.md`
   - `agent_docs/tech_stack.md`
   - `agent_docs/active_context.md`
   - `agent_docs/verification.md`
3. Start work through `prompt-engineer`.
4. Let the owning agent implement.
5. Use `tester` to verify runtime behavior.
6. Use `reviewer` for final risk review.

## Default Flow

`prompt-engineer` -> implementation agent(s) -> `tester` -> `reviewer`

## Key Idea

Do not dump the whole repo context into every task.

Use short, durable docs and load only the files needed for the current pass.
