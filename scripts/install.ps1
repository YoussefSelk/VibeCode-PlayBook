param(
  [string]$Destination = ".",
  [switch]$Force,
  [switch]$Backup,
  [string]$Assistant,
  [string]$RepoBase = "https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main"
)

$ErrorActionPreference = "Stop"
$RepoBase = $RepoBase.TrimEnd("/")

function Write-Info {
  param([string]$Message)
  Write-Host $Message -ForegroundColor Cyan
}

function Write-WarnLine {
  param([string]$Message)
  Write-Host $Message -ForegroundColor Yellow
}

function Write-Success {
  param([string]$Message)
  Write-Host $Message -ForegroundColor Green
}

function Show-Banner {
  Write-Host "" 
  Write-Host "__     ___ _          ____          _                 " -ForegroundColor DarkCyan
  Write-Host "\ \   / (_) |__   ___/ ___|___   __| | ___ _ __ ___   " -ForegroundColor DarkCyan
  Write-Host " \ \ / /| | '_ \ / _ \ |   / _ \ / _` |/ _ \ '__/ __|  " -ForegroundColor DarkCyan
  Write-Host "  \ V / | | |_) |  __/ |__| (_) | (_| |  __/ |  \__ \  " -ForegroundColor DarkCyan
  Write-Host "   \_/  |_|_.__/ \___|\____\___/ \__,_|\___|_|  |___/  " -ForegroundColor DarkCyan
  Write-Host "" 
  Write-Host "Playbook Installer" -ForegroundColor Magenta
  Write-Host ""
}

$commonFiles = @(
  "AGENTS.md",
  ".ai/.agents/README.md",
  ".ai/.agents/roles.md",
  ".ai/.agents/reference-links.md",
  "agent_docs/README.md",
  "agent_docs/project_brief.md",
  "agent_docs/tech_stack.md",
  "agent_docs/active_context.md",
  "agent_docs/verification.md",
  "agent_docs/decisions.md"
)

$assistantPacks = @{
  "codex" = @(
    @{ Source = ".ai/.codex/config.toml"; Target = ".codex/config.toml" },
    @{ Source = ".ai/.codex/agents/prompt-engineer.toml"; Target = ".codex/agents/prompt-engineer.toml" },
    @{ Source = ".ai/.codex/agents/db.toml"; Target = ".codex/agents/db.toml" },
    @{ Source = ".ai/.codex/agents/backend.toml"; Target = ".codex/agents/backend.toml" },
    @{ Source = ".ai/.codex/agents/frontend.toml"; Target = ".codex/agents/frontend.toml" },
    @{ Source = ".ai/.codex/agents/tester.toml"; Target = ".codex/agents/tester.toml" },
    @{ Source = ".ai/.codex/agents/security.toml"; Target = ".codex/agents/security.toml" },
    @{ Source = ".ai/.codex/agents/legal.toml"; Target = ".codex/agents/legal.toml" },
    @{ Source = ".ai/.codex/agents/devops.toml"; Target = ".codex/agents/devops.toml" },
    @{ Source = ".ai/.codex/agents/reviewer.toml"; Target = ".codex/agents/reviewer.toml" }
  )
  "claude" = @(
    @{ Source = ".ai/.claude/CLAUDE.md"; Target = "CLAUDE.md" },
    @{ Source = ".ai/.claude/commands/plan.md"; Target = ".claude/commands/plan.md" },
    @{ Source = ".ai/.claude/commands/review.md"; Target = ".claude/commands/review.md" },
    @{ Source = ".ai/.claude/commands/test.md"; Target = ".claude/commands/test.md" },
    @{ Source = ".ai/.claude/commands/security-check.md"; Target = ".claude/commands/security-check.md" },
    @{ Source = ".ai/.claude/commands/legal-check.md"; Target = ".claude/commands/legal-check.md" },
    @{ Source = ".ai/.claude/agents/prompt-engineer.md"; Target = ".claude/agents/prompt-engineer.md" },
    @{ Source = ".ai/.claude/agents/db.md"; Target = ".claude/agents/db.md" },
    @{ Source = ".ai/.claude/agents/backend.md"; Target = ".claude/agents/backend.md" },
    @{ Source = ".ai/.claude/agents/frontend.md"; Target = ".claude/agents/frontend.md" },
    @{ Source = ".ai/.claude/agents/tester.md"; Target = ".claude/agents/tester.md" },
    @{ Source = ".ai/.claude/agents/security.md"; Target = ".claude/agents/security.md" },
    @{ Source = ".ai/.claude/agents/legal.md"; Target = ".claude/agents/legal.md" },
    @{ Source = ".ai/.claude/agents/devops.md"; Target = ".claude/agents/devops.md" },
    @{ Source = ".ai/.claude/agents/reviewer.md"; Target = ".claude/agents/reviewer.md" }
  )
  "github" = @(
    @{ Source = ".ai/.github/copilot-instructions.md"; Target = ".github/copilot-instructions.md" },
    @{ Source = ".ai/.github/instructions/agent-workflow.instructions.md"; Target = ".github/instructions/agent-workflow.instructions.md" },
    @{ Source = ".ai/.github/agents/db.agent.md"; Target = ".github/agents/db.agent.md" },
    @{ Source = ".ai/.github/agents/backend.agent.md"; Target = ".github/agents/backend.agent.md" },
    @{ Source = ".ai/.github/agents/frontend.agent.md"; Target = ".github/agents/frontend.agent.md" },
    @{ Source = ".ai/.github/agents/prompt-engineer.agent.md"; Target = ".github/agents/prompt-engineer.agent.md" },
    @{ Source = ".ai/.github/agents/tester.agent.md"; Target = ".github/agents/tester.agent.md" },
    @{ Source = ".ai/.github/agents/security.agent.md"; Target = ".github/agents/security.agent.md" },
    @{ Source = ".ai/.github/agents/legal.agent.md"; Target = ".github/agents/legal.agent.md" },
    @{ Source = ".ai/.github/agents/devops.agent.md"; Target = ".github/agents/devops.agent.md" },
    @{ Source = ".ai/.github/agents/reviewer.agent.md"; Target = ".github/agents/reviewer.agent.md" }
  )
}

function Save-Backup {
  param([string]$PathToBackup)

  $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $backupPath = "$PathToBackup.bak.$timestamp"
  Copy-Item -LiteralPath $PathToBackup -Destination $backupPath -Force
  return $backupPath
}

function Select-Assistant {
  param([string]$CurrentChoice)

  if ($CurrentChoice) {
    return $CurrentChoice.ToLowerInvariant()
  }

  if ([Console]::IsInputRedirected -or [Console]::IsOutputRedirected) {
    return "codex"
  }

  Write-Host "Select assistant pack:" -ForegroundColor White
  Write-Host "  1) codex" -ForegroundColor White
  Write-Host "  2) claude" -ForegroundColor White
  Write-Host "  3) github" -ForegroundColor White

  while ($true) {
    $choice = (Read-Host "Enter choice [1-3] (default: 1)").Trim()
    switch ($choice) {
      "" { return "codex" }
      "1" { return "codex" }
      "2" { return "claude" }
      "3" { return "github" }
      default { Write-WarnLine "Invalid choice. Please enter 1, 2, or 3." }
    }
  }

}

$assistantKey = Select-Assistant -CurrentChoice $Assistant

if (-not $assistantPacks.ContainsKey($assistantKey)) {
  throw "Unsupported assistant '$Assistant'. Use codex, claude, or github."
}

$resolvedDestination = Resolve-Path -LiteralPath $Destination -ErrorAction SilentlyContinue
if (-not $resolvedDestination) {
  New-Item -ItemType Directory -Path $Destination -Force | Out-Null
  $resolvedDestination = Resolve-Path -LiteralPath $Destination
}

$targetRoot = $resolvedDestination.Path

$files = @()
foreach ($relativePath in $commonFiles) {
  $targetPath = $relativePath
  if ($relativePath -eq ".ai/.agents/README.md") {
    $targetPath = ".agents/README.md"
  } elseif ($relativePath -eq ".ai/.agents/roles.md") {
    $targetPath = ".agents/roles.md"
  } elseif ($relativePath -eq ".ai/.agents/reference-links.md") {
    $targetPath = ".agents/reference-links.md"
  }

  $files += @{ Source = $relativePath; Target = $targetPath }
}
$files += $assistantPacks[$assistantKey]

Write-Host "Installing VibeCoders Playbook into $targetRoot"
Show-Banner
Write-Info "Installing VibeCoders Playbook into $targetRoot"
Write-Info "Assistant pack: $assistantKey"

$downloaded = 0
$skipped = 0
$backedUp = 0

foreach ($file in $files) {
  $sourcePath = $file.Source
  $targetPath = Join-Path $targetRoot $file.Target
  $targetDir = Split-Path -Parent $targetPath

  if (-not (Test-Path -LiteralPath $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
  }

  if ((Test-Path -LiteralPath $targetPath) -and (-not $Force)) {
    Write-WarnLine "Skipping existing file: $($file.Target)"
    $skipped++
    continue
  }

  if ((Test-Path -LiteralPath $targetPath) -and $Force -and $Backup) {
    $backupPath = Save-Backup -PathToBackup $targetPath
    Write-Info "Backed up existing file: $($file.Target) -> $backupPath"
    $backedUp++
  }

  $url = "$RepoBase/$sourcePath"
  $tempPath = "$targetPath.tmp"
  Write-Info "Fetching $($file.Target)"
  try {
    Invoke-WebRequest -Uri $url -OutFile $tempPath
    Move-Item -LiteralPath $tempPath -Destination $targetPath -Force
  } catch {
    if (Test-Path -LiteralPath $tempPath) {
      Remove-Item -LiteralPath $tempPath -Force -ErrorAction SilentlyContinue
    }
    throw "Failed to fetch '$sourcePath' from '$url'. $($_.Exception.Message)"
  }
  $downloaded++
}

Write-Host ""
Write-Success "Install complete."
Write-Info "Assistant pack: $assistantKey"
Write-Info "Downloaded: $downloaded"
Write-Info "Skipped: $skipped"
if ($Backup) {
  Write-Info "Backed up: $backedUp"
}
Write-Host "Next steps:" -ForegroundColor White
Write-Host "1. Review AGENTS.md" -ForegroundColor White
Write-Host "2. Fill in agent_docs/project_brief.md" -ForegroundColor White
Write-Host "3. Fill in agent_docs/tech_stack.md" -ForegroundColor White
Write-Host "4. Fill in agent_docs/active_context.md" -ForegroundColor White
switch ($assistantKey) {
  "codex" { Write-Host "5. Open the repo with Codex and start with prompt-engineer" -ForegroundColor White }
  "claude" { Write-Host "5. Open CLAUDE.md in your Claude workflow and start with prompt-engineer" -ForegroundColor White }
  "github" { Write-Host "5. Open GitHub Copilot Chat and use .github/copilot-instructions.md plus prompt-engineer" -ForegroundColor White }
}
