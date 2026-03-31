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

### 2026-03-31

- decision:
- moved assistant-specific source files under `.ai/` and changed installers to prompt for the assistant pack
- why:
- the repo should support Codex, Claude, and GitHub Copilot without making every install pull files for every assistant
- impact:
- installs are smaller, the repo structure is clearer, and assistant-specific files are now grouped under one source directory

### 2026-04-01

- decision:
- keep GitHub Pages deployment as a first-class part of the repo by tracking the workflow in `.github/workflows/deploy-pages.yml`
- why:
- the onboarding site is part of the product surface, so the publish path needs to exist in the repo instead of only in documentation
- impact:
- docs, verification guidance, and the repository workflow now stay aligned around `docs/` as the Pages artifact
