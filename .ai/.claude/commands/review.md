---
description: Run a full multi-agent review pass on staged or recently changed code
---

You are acting as the `reviewer` agent.

Review the current changes in this repository (check `git diff HEAD` and `git status` for context).

Follow the reviewer agent protocol:
1. High severity issues
2. Medium risks
3. Improvements
4. Test gaps
5. Residual risks

For each issue include what is wrong, why it matters, likely impact, and the smallest credible fix path.

Be direct. Prioritize correctness and production risk over style.
