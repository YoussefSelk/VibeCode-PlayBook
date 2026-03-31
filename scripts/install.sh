#!/usr/bin/env bash

set -euo pipefail

DESTINATION="."
FORCE="${FORCE:-0}"
BACKUP="${BACKUP:-0}"
REPO_BASE="${REPO_BASE:-https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main}"

FILES=(
  ".codex/config.toml"
  ".codex/agents/prompt-engineer.toml"
  ".codex/agents/db.toml"
  ".codex/agents/backend.toml"
  ".codex/agents/frontend.toml"
  ".codex/agents/tester.toml"
  ".codex/agents/reviewer.toml"
  "AGENTS.md"
  "agent_docs/README.md"
  "agent_docs/project_brief.md"
  "agent_docs/tech_stack.md"
  "agent_docs/active_context.md"
  "agent_docs/verification.md"
  "agent_docs/decisions.md"
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

mkdir -p "$DESTINATION"
cd "$DESTINATION"

echo "Installing VibeCode PlayBook into $(pwd)"

downloaded=0
skipped=0
backed_up=0

for relative_path in "${FILES[@]}"; do
  target_dir="$(dirname "$relative_path")"
  mkdir -p "$target_dir"

  if [[ -f "$relative_path" && "$FORCE" != "1" ]]; then
    echo "Skipping existing file: $relative_path"
    skipped=$((skipped + 1))
    continue
  fi

  if [[ -f "$relative_path" && "$FORCE" == "1" && "$BACKUP" == "1" ]]; then
    backup_path="${relative_path}.bak.$(date +%Y%m%d-%H%M%S)"
    cp "$relative_path" "$backup_path"
    echo "Backed up existing file: $relative_path -> $backup_path"
    backed_up=$((backed_up + 1))
  fi

  echo "Fetching $relative_path"
  temp_path="${relative_path}.tmp"
  download_file "$REPO_BASE/$relative_path" "$temp_path"
  mv "$temp_path" "$relative_path"
  downloaded=$((downloaded + 1))
done

echo
echo "Install complete."
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
echo "5. Start using prompt-engineer in your project"
