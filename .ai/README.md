# AI Packs

This folder is the source of truth for assistant-specific install packs.

Common repo files:

- `AGENTS.md`
- `agent_docs/*`
- `.agents/reference-links.md`

Assistant packs:

- `.ai/.codex/` -> installs to `.codex/`
- `.ai/.claude/` -> installs `CLAUDE.md`
- `.ai/.github/` -> installs `.github/copilot-instructions.md`

The installer scripts download the common files plus only the selected assistant pack.

All packs follow the same inter-agent handoff contract from `AGENTS.md` to keep collaboration reliable across Claude, GitHub Copilot, and Codex.
