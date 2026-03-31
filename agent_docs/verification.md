# Verification

## Required Checks

- unit tests:
- none configured
- integration tests:
- none configured
- end-to-end tests:
- for the docs site, verify the GitHub Pages deployment flow from push to published site
- lint:
- none configured
- typecheck:
- none configured

## Manual Validation

- flow 1:
- open `docs/index.html` and confirm navigation, section links, and local asset loading work
- flow 2:
- confirm `docs/llms.txt` and `docs/llms-full.txt` accurately reflect the workflow and key files

## High-Risk Areas

- contracts:
- consistency between `AGENTS.md`, `README.md`, `agent_docs/*`, and the docs site
- auth:
- not applicable in the current repo, but the workflow must still route auth-sensitive downstream work to `security`
- migrations:
- not applicable
- async flows:
- GitHub Pages deployment workflow and any future publishing automation

## Done Criteria

A change is not done until:
- the owning layer is correct
- the runtime flow is verified
- reviewer-level risks are acceptable
