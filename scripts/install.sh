#!/usr/bin/env bash

set -euo pipefail

DESTINATION="."
FORCE="${FORCE:-0}"
BACKUP="${BACKUP:-0}"
ASSISTANT="${ASSISTANT:-}"
REPO_BASE="${REPO_BASE:-https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main}"
REPO_BASE="${REPO_BASE%/}"

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET='\033[0m'
  C_INFO='\033[36m'
  C_WARN='\033[33m'
  C_OK='\033[32m'
  C_ACCENT='\033[35m'
else
  C_RESET=''
  C_INFO=''
  C_WARN=''
  C_OK=''
  C_ACCENT=''
fi

print_banner() {
  printf '%b\n' ""
  printf '%b\n' "${C_INFO}========================================${C_RESET}"
  printf '%b\n' "${C_ACCENT}VibeCoders Playbook Installer${C_RESET}"
  printf '%b\n' "${C_INFO}========================================${C_RESET}"
  printf '%b\n' ""
}

print_info() {
  printf '%b\n' "${C_INFO}$1${C_RESET}"
}

print_warn() {
  printf '%b\n' "${C_WARN}$1${C_RESET}"
}

print_ok() {
  printf '%b\n' "${C_OK}$1${C_RESET}"
}

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
  ".ai/.claude/commands/plan.md:.claude/commands/plan.md"
  ".ai/.claude/commands/review.md:.claude/commands/review.md"
  ".ai/.claude/commands/test.md:.claude/commands/test.md"
  ".ai/.claude/commands/security-check.md:.claude/commands/security-check.md"
  ".ai/.claude/commands/legal-check.md:.claude/commands/legal-check.md"
)

GITHUB_PACK=(
  ".ai/.github/copilot-instructions.md:.github/copilot-instructions.md"
  ".ai/.github/instructions/agent-workflow.instructions.md:.github/instructions/agent-workflow.instructions.md"
  ".ai/.github/agents/db.agent.md:.github/agents/db.agent.md"
  ".ai/.github/agents/backend.agent.md:.github/agents/backend.agent.md"
  ".ai/.github/agents/frontend.agent.md:.github/agents/frontend.agent.md"
  ".ai/.github/agents/prompt-engineer.agent.md:.github/agents/prompt-engineer.agent.md"
  ".ai/.github/agents/tester.agent.md:.github/agents/tester.agent.md"
  ".ai/.github/agents/security.agent.md:.github/agents/security.agent.md"
  ".ai/.github/agents/legal.agent.md:.github/agents/legal.agent.md"
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
      REPO_BASE="${REPO_BASE%/}"
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

  printf 'codex'
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

print_banner
print_info "Installing VibeCoders Playbook into $(pwd)"
print_info "Assistant pack: $assistant_key"

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
    print_warn "Skipping existing file: $target_path"
    skipped=$((skipped + 1))
    continue
  fi

  if [[ -f "$target_path" && "$FORCE" == "1" && "$BACKUP" == "1" ]]; then
    backup_path="${target_path}.bak.$(date +%Y%m%d-%H%M%S)"
    cp "$target_path" "$backup_path"
    print_info "Backed up existing file: $target_path -> $backup_path"
    backed_up=$((backed_up + 1))
  fi

  print_info "Fetching $target_path"
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
    print_warn "Skipping existing file: $target_path"
    skipped=$((skipped + 1))
    continue
  fi

  if [[ -f "$target_path" && "$FORCE" == "1" && "$BACKUP" == "1" ]]; then
    backup_path="${target_path}.bak.$(date +%Y%m%d-%H%M%S)"
    cp "$target_path" "$backup_path"
    print_info "Backed up existing file: $target_path -> $backup_path"
    backed_up=$((backed_up + 1))
  fi

  print_info "Fetching $target_path"
  temp_path="${target_path}.tmp"
  download_file "$REPO_BASE/$source_path" "$temp_path"
  mv "$temp_path" "$target_path"
  downloaded=$((downloaded + 1))
done

echo
print_ok "Install complete."
print_info "Assistant pack: $assistant_key"
print_info "Downloaded: $downloaded"
print_info "Skipped: $skipped"
if [[ "$BACKUP" == "1" ]]; then
  print_info "Backed up: $backed_up"
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
