#!/usr/bin/env bash

set -euo pipefail

DESTINATION="."
FORCE="${FORCE:-0}"
BACKUP="${BACKUP:-0}"
ASSISTANT="${ASSISTANT:-}"
REPO_BASE="${REPO_BASE:-https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main}"

COMMON_FILES=(
  "AGENTS.md"
  ".ai/.agents/README.md:.agents/README.md"
  ".ai/.agents/roles.md:.agents/roles.md"
  "agent_docs/README.md"
  "agent_docs/project_brief.md"
  "agent_docs/tech_stack.md"
  "agent_docs/active_context.md"
  "agent_docs/verification.md"
  "agent_docs/decisions.md"
)

CODEX_PACK=(
  ".ai/.codex/config.toml:.codex/config.toml"
  ".ai/.codex/agents/prompt-engineer.toml:.codex/agents/prompt-engineer.toml"
  ".ai/.codex/agents/db.toml:.codex/agents/db.toml"
  ".ai/.codex/agents/backend.toml:.codex/agents/backend.toml"
  ".ai/.codex/agents/frontend.toml:.codex/agents/frontend.toml"
  ".ai/.codex/agents/tester.toml:.codex/agents/tester.toml"
  ".ai/.codex/agents/security.toml:.codex/agents/security.toml"
  ".ai/.codex/agents/legal.toml:.codex/agents/legal.toml"
  ".ai/.codex/agents/reviewer.toml:.codex/agents/reviewer.toml"
)

CLAUDE_PACK=(
  ".ai/.claude/CLAUDE.md:CLAUDE.md"
)

GITHUB_PACK=(
  ".ai/.github/copilot-instructions.md:.github/copilot-instructions.md"
  ".ai/.github/instructions/agent-workflow.instructions.md:.github/instructions/agent-workflow.instructions.md"
  ".ai/.github/agents/prompt-engineer.agent.md:.github/agents/prompt-engineer.agent.md"
  ".ai/.github/agents/tester.agent.md:.github/agents/tester.agent.md"
  ".ai/.github/agents/reviewer.agent.md:.github/agents/reviewer.agent.md"
)

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--destination)
      DESTINATION="${2:?Missing destination path}"
      shift 2
      ;;
    -f|--force)
      FORCE=1
      shift
      ;;
    -b|--backup)
      BACKUP=1
      shift
      ;;
    -a|--assistant)
      ASSISTANT="${2:?Missing assistant name}"
      shift 2
      ;;
    --repo-base)
      REPO_BASE="${2:?Missing repo base URL}"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

download_file() {
  local url="$1"
  local output="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$output"
    return
  fi

  if command -v wget >/dev/null 2>&1; then
    wget -qO "$output" "$url"
    return
  fi

  echo "Error: curl or wget is required to download files." >&2
  exit 1
}

select_assistant() {
  local current="${1:-}"

  if [[ -n "$current" ]]; then
    printf '%s' "${current,,}"
    return
  fi

  if [[ ! -r /dev/tty ]]; then
    echo "No interactive terminal found. Re-run with --assistant codex|claude|github." >&2
    exit 1
  fi

  echo >&2
  echo "Choose the assistant pack to install:" >&2
  echo "1. Codex" >&2
  echo "2. Claude" >&2
  echo "3. GitHub Copilot" >&2

  while true; do
    printf 'Enter 1, 2, or 3: ' > /dev/tty
    read -r selection < /dev/tty
    case "$selection" in
      1) printf 'codex'; return ;;
      2) printf 'claude'; return ;;
      3) printf 'github'; return ;;
      *) echo "Please enter 1, 2, or 3." >&2 ;;
    esac
  done
}

assistant_key="$(select_assistant "$ASSISTANT")"

case "$assistant_key" in
  codex) ASSISTANT_PACK=("${CODEX_PACK[@]}") ;;
  claude) ASSISTANT_PACK=("${CLAUDE_PACK[@]}") ;;
  github) ASSISTANT_PACK=("${GITHUB_PACK[@]}") ;;
  *)
    echo "Unsupported assistant '$assistant_key'. Use codex, claude, or github." >&2
    exit 1
    ;;
esac

mkdir -p "$DESTINATION"
cd "$DESTINATION"

echo "Installing VibeCoders-PlayBook into $(pwd)"
echo "Assistant pack: $assistant_key"

downloaded=0
skipped=0
backed_up=0

for relative_path in "${COMMON_FILES[@]}"; do
  source_path="${relative_path%%:*}"
  target_path="${relative_path#*:}"
  if [[ "$relative_path" != *:* ]]; then
    source_path="$relative_path"
    target_path="$relative_path"
  fi

  target_dir="$(dirname "$target_path")"
  mkdir -p "$target_dir"

  if [[ -f "$target_path" && "$FORCE" != "1" ]]; then
    echo "Skipping existing file: $target_path"
    skipped=$((skipped + 1))
    continue
  fi

  if [[ -f "$target_path" && "$FORCE" == "1" && "$BACKUP" == "1" ]]; then
    backup_path="${target_path}.bak.$(date +%Y%m%d-%H%M%S)"
    cp "$target_path" "$backup_path"
    echo "Backed up existing file: $target_path -> $backup_path"
    backed_up=$((backed_up + 1))
  fi

  echo "Fetching $target_path"
  temp_path="${target_path}.tmp"
  download_file "$REPO_BASE/$source_path" "$temp_path"
  mv "$temp_path" "$target_path"
  downloaded=$((downloaded + 1))
done

for pack_entry in "${ASSISTANT_PACK[@]}"; do
  source_path="${pack_entry%%:*}"
  target_path="${pack_entry#*:}"
  target_dir="$(dirname "$target_path")"
  mkdir -p "$target_dir"

  if [[ -f "$target_path" && "$FORCE" != "1" ]]; then
    echo "Skipping existing file: $target_path"
    skipped=$((skipped + 1))
    continue
  fi

  if [[ -f "$target_path" && "$FORCE" == "1" && "$BACKUP" == "1" ]]; then
    backup_path="${target_path}.bak.$(date +%Y%m%d-%H%M%S)"
    cp "$target_path" "$backup_path"
    echo "Backed up existing file: $target_path -> $backup_path"
    backed_up=$((backed_up + 1))
  fi

  echo "Fetching $target_path"
  temp_path="${target_path}.tmp"
  download_file "$REPO_BASE/$source_path" "$temp_path"
  mv "$temp_path" "$target_path"
  downloaded=$((downloaded + 1))
done

echo
echo "Install complete."
echo "Assistant pack: $assistant_key"
echo "Downloaded: $downloaded"
echo "Skipped: $skipped"
if [[ "$BACKUP" == "1" ]]; then
  echo "Backed up: $backed_up"
fi
echo "Next steps:"
echo "1. Review AGENTS.md"
echo "2. Fill in agent_docs/project_brief.md"
echo "3. Fill in agent_docs/tech_stack.md"
echo "4. Fill in agent_docs/active_context.md"
case "$assistant_key" in
  codex) echo "5. Open the repo with Codex and start with prompt-engineer" ;;
  claude) echo "5. Open CLAUDE.md in your Claude workflow and start with prompt-engineer" ;;
  github) echo "5. Open GitHub Copilot Chat and use .github/copilot-instructions.md plus prompt-engineer" ;;
esac
