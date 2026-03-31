# Tech Stack

## Stack

- frontend:
- static HTML, CSS, and vanilla JavaScript for the docs site
- backend:
- none in this repository
- database:
- none in this repository
- auth:
- none in this repository
- hosting:
- GitHub repository content
- GitHub Pages via GitHub Actions for the `docs/` site

## Commands

- install:
- run `scripts/install.ps1`, `scripts/install.sh`, or `scripts/install.cmd` from the target project workflow
- dev:
- open `docs/index.html` locally for the static site
- test:
- no formal automated test suite currently configured
- lint:
- no formal linter currently configured
- build:
- no build step required for the static docs site

## Architecture Notes

- entry points:
- `README.md`
- `AGENTS.md`
- `docs/index.html`
- `scripts/install.*`
- key modules:
- `.codex/agents/*`
- `agent_docs/*`
- `docs/*`
- important boundaries:
- playbook guidance belongs in docs and durable markdown
- installer logic belongs in `scripts/`
- the docs site should remain static and dependency-light

## Environment

- required env vars:
- none for the static docs site
- local setup notes:
- GitHub Pages deployment depends on repository Pages settings and workflow permissions

## Libraries / Framework Rules

- established patterns to follow:
- prefer simple, inspectable files and avoid unnecessary abstractions
- libraries already in use:
- none beyond platform tools and browser-native web features for the docs site
- avoid introducing:
- heavy frontend frameworks for the docs site unless the repo meaningfully outgrows static hosting needs
