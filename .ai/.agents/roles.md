# VibeCoders-PlayBook Roles

Use these roles as the shared workflow model across assistants.

- `prompt-engineer`
  Turns rough asks into clear execution prompts and chooses the right sequence.

- `db`
  Owns schema, migrations, queries, and persistence-layer contracts.

- `backend`
  Owns APIs, business logic, validation, auth, and backend contracts.

- `frontend`
  Owns UI, client behavior, accessibility, and frontend-side integration.

- `tester`
  Verifies the real runtime flow across layers.

- `security`
  Reviews auth, permissions, secrets, uploads, risky integrations, and sensitive data.

- `legal`
  Reviews privacy, consent, retention, analytics, disclosures, and risky claims.

- `reviewer`
  Performs the final regression and risk review.

Default sequence:
`prompt-engineer` -> owning role(s) -> `tester` -> `reviewer`
