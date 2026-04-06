# Shared Agent Resources

This folder contains assistant-agnostic role docs used by installer common files.

## Files

- roles.md: compact role summary shared across assistant packs
- reference-links.md: curated cross-domain engineering links for objective-based agent research

## Collaboration Contract

- `AGENTS.md` defines the required inter-agent handoff contract.
- Use the same handoff fields across Claude, GitHub Copilot, and Codex:
  - goal
  - scope
  - changes
  - evidence
  - risks
  - next-owner
  - done-criteria
