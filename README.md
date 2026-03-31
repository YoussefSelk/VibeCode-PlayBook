
# VibeCoders-PlayBook

This repo is a lean Codex multi-agent layer you can drop into a real project.

Purpose:
- better agent coordination
- less repeated context
- fewer wasted tokens
- stronger end-to-end validation

## What Matters

- `AGENTS.md`
  Main operating rules for the whole team.

- `.codex/agents/`
  Specialized agents:
  - `prompt-engineer`
  - `db`
  - `backend`
  - `frontend`
  - `tester`
  - `reviewer`

- `agent_docs/`
  Progressive-disclosure context files.
  Only load what the current task needs.

## Recommended Use

1. Add it to your real project with one command.
2. Fill in:
   - `agent_docs/project_brief.md`
   - `agent_docs/tech_stack.md`
   - `agent_docs/active_context.md`
   - `agent_docs/verification.md`
3. Start work through `prompt-engineer`.
4. Let the owning agent implement.
5. Use `tester` to verify runtime behavior.
6. Use `reviewer` for final risk review.

## Default Flow

`prompt-engineer` -> implementation agent(s) -> `tester` -> `reviewer`

## One-Command Install

PowerShell:

```powershell
iex "& { $(irm https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.ps1) }"
```

PowerShell into a specific folder:

```powershell
iex "& { $(irm https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.ps1) } -Destination 'C:\path\to\your\project'"
```

PowerShell overwrite existing files:

```powershell
iex "& { $(irm https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.ps1) } -Destination 'C:\path\to\your\project' -Force"
```

PowerShell overwrite and create backups first:

```powershell
iex "& { $(irm https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.ps1) } -Destination 'C:\path\to\your\project' -Force -Backup"
```

Bash:

```bash
curl -fsSL https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.sh | bash
```

Bash into a specific folder:

```bash
curl -fsSL https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.sh | bash -s -- --destination /path/to/your/project
```

Bash overwrite existing files:

```bash
curl -fsSL https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.sh | bash -s -- --destination /path/to/your/project --force
```

Bash overwrite and create backups first:

```bash
curl -fsSL https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.sh | bash -s -- --destination /path/to/your/project --force --backup
```

The installer adds only the core files:
- `AGENTS.md`
- `.codex/config.toml`
- `.codex/agents/*`
- `agent_docs/*`

Behavior:
- existing files are skipped by default
- `-Force` or `--force` overwrites existing files
- `-Backup` or `--backup` creates timestamped backups before overwrite
- PowerShell uses `Invoke-WebRequest`
- Bash uses `curl`, or `wget` if `curl` is unavailable

## Key Idea

Do not dump the whole repo context into every task.

Use short, durable docs and load only the files needed for the current pass.
