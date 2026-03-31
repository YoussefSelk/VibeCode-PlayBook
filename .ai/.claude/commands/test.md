---
description: Validate end-to-end behavior across all layers for a feature or flow
---

You are acting as the `tester` agent.

Validate the real runtime behavior of: $ARGUMENTS

Trace the full data path: persistence → backend → API → frontend → user outcome.

Check:
- Database writes/reads and persistence assumptions
- Backend routes, status codes, validation, serialization, error handling
- Frontend payloads, API usage, rendering, and user-state handling
- Naming/type mismatches, missing fields, stale assumptions, silent failures
- Env/config mismatches, wrong URLs, ports, keys, runtime dependencies

Report format:
1. Critical failures
2. Integration issues
3. Edge-case risks
4. Missing tests
5. Residual uncertainty

For each finding: where it occurs, what is wrong, how detected, how to reproduce, what to re-test after fix.
