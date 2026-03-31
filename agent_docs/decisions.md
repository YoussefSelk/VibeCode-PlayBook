# Decisions

Record only decisions that should survive across sessions.

## Decision Log

### 2026-03-31

- decision:
- added a static documentation site under `docs/` instead of introducing a framework
- why:
- the repo is documentation-heavy, and GitHub Pages plus plain files keeps the site lightweight and easy for LLMs to parse
- impact:
- the site can deploy without a build step and remains easy to maintain

### 2026-03-31

- decision:
- added `docs/llms.txt` and `docs/llms-full.txt` as machine-readable onboarding files
- why:
- the repo is specifically meant to help both humans and agents use the workflow correctly
- impact:
- AI consumers now have a compact and explicit entry point that mirrors `AGENTS.md`
