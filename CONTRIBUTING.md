# Contributing

This repository is designed for fast, collaborative "vibe coding" with Codex and specialized agents.

## How We Work

We optimize for:
- fast iteration
- clear ownership
- small focused changes
- strong end-to-end verification
- honest review before calling work done

## Default Flow

1. Start with a rough request or a short brief.
2. Use `prompt-engineer` to shape it into an execution-ready prompt.
3. Delegate by ownership:
   - `db`
   - `backend`
   - `frontend`
4. Use `tester` to verify the real behavior end to end.
5. Use `reviewer` for the final risk and regression pass.

## Contribution Rules

- Prefer small pull requests and focused diffs.
- Do not mix unrelated work in one change.
- Keep ownership clear across layers.
- If contracts change between DB, backend, and frontend, verify both sides.
- Do not treat passing tests as proof that the system works.
- Favor runtime validation for cross-stack changes.

## Before Opening a PR

- Confirm the task goal is clear.
- Confirm the right agent(s) handled the right layers.
- Confirm `tester` verified the real flow for user-facing or multi-layer work.
- Confirm `reviewer` checked for regressions, risk, and missing coverage.
- Update docs or templates if the workflow changed.

## Good Contributions to This Repo

- better agent instructions
- stronger prompt templates
- improved docs for multi-agent workflows
- stronger team operating patterns
- starter project structures that fit the vibe-coding model

## Avoid

- vague one-line changes with no validation
- giant mixed refactors without clear payoff
- skipping runtime verification on integration work
- merging prompt or workflow changes without documenting the new pattern
