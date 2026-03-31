# Active Context

This is the most important context file for day-to-day work.
Keep it short.

## Current Goal

- publish a GitHub Pages-ready onboarding site for the playbook
- make the repo easier for both humans and LLMs to understand quickly

## Active Scope

- in scope:
- static docs site in `docs/`
- LLM-readable onboarding files
- Pages deployment workflow
- minimal durable doc updates for discoverability
- out of scope:
- changing installer behavior
- introducing a frontend framework or build pipeline

## Current Task

- task:
- harden and document the GitHub Pages site so the onboarding flow and deployment path are both ready to use
- owner agent(s):
- prompt-engineer
- frontend
- tester
- reviewer

## Known Issues

- issue 1:
- durable project docs were mostly placeholders before the docs site pass
- issue 2:
- GitHub Pages still needs to be enabled in the repository settings if not already configured

## Validation Needed

- checks to run:
- verify `docs/index.html` references local assets correctly
- verify GitHub Actions workflow targets `docs/`
- verify the docs interactions still work when served locally
- runtime flow to verify:
- a push to `main` should publish the static site to GitHub Pages

## Next Step

- enable GitHub Pages if needed, then review the live deployed site and refine copy or sections based on real onboarding needs
