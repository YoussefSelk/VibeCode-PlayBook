param(
  [string]$Destination = ".",
  [switch]$Force,
  [switch]$Backup,
  [string]$Assistant,
  [string]$RepoBase = "https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main"
)

$ErrorActionPreference = "Stop"

$commonFiles = @(
  "AGENTS.md",
  ".ai/.agents/README.md",
  ".ai/.agents/roles.md",
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
    @{ Source = ".ai/.codex/agents/reviewer.toml"; Target = ".codex/agents/reviewer.toml" }
  )
  "claude" = @(
    @{ Source = ".ai/.claude/CLAUDE.md"; Target = "CLAUDE.md" }
  )
  "github" = @(
    @{ Source = ".ai/.github/copilot-instructions.md"; Target = ".github/copilot-instructions.md" },
    @{ Source = ".ai/.github/instructions/agent-workflow.instructions.md"; Target = ".github/instructions/agent-workflow.instructions.md" },
    @{ Source = ".ai/.github/agents/prompt-engineer.agent.md"; Target = ".github/agents/prompt-engineer.agent.md" },
    @{ Source = ".ai/.github/agents/tester.agent.md"; Target = ".github/agents/tester.agent.md" },
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

  Write-Host ""
  Write-Host "Choose the assistant pack to install:"
  Write-Host "1. Codex"
  Write-Host "2. Claude"
  Write-Host "3. GitHub Copilot"

  while ($true) {
    $selection = (Read-Host "Enter 1, 2, or 3").Trim()

    switch ($selection) {
      "1" { return "codex" }
      "2" { return "claude" }
      "3" { return "github" }
      default { Write-Host "Please enter 1, 2, or 3." }
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
  }

  $files += @{ Source = $relativePath; Target = $targetPath }
}
$files += $assistantPacks[$assistantKey]

Write-Host "Installing VibeCoders-PlayBook into $targetRoot"
Write-Host "Assistant pack: $assistantKey"

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
    Write-Host "Skipping existing file: $($file.Target)"
    $skipped++
    continue
  }

  if ((Test-Path -LiteralPath $targetPath) -and $Force -and $Backup) {
    $backupPath = Save-Backup -PathToBackup $targetPath
    Write-Host "Backed up existing file: $($file.Target) -> $backupPath"
    $backedUp++
  }

  $url = "$RepoBase/$sourcePath"
  $tempPath = "$targetPath.tmp"
  Write-Host "Fetching $($file.Target)"
  Invoke-WebRequest -Uri $url -OutFile $tempPath
  Move-Item -LiteralPath $tempPath -Destination $targetPath -Force
  $downloaded++
}

Write-Host ""
Write-Host "Install complete."
Write-Host "Assistant pack: $assistantKey"
Write-Host "Downloaded: $downloaded"
Write-Host "Skipped: $skipped"
if ($Backup) {
  Write-Host "Backed up: $backedUp"
}
Write-Host "Next steps:"
Write-Host "1. Review AGENTS.md"
Write-Host "2. Fill in agent_docs/project_brief.md"
Write-Host "3. Fill in agent_docs/tech_stack.md"
Write-Host "4. Fill in agent_docs/active_context.md"
switch ($assistantKey) {
  "codex" { Write-Host "5. Open the repo with Codex and start with prompt-engineer" }
  "claude" { Write-Host "5. Open CLAUDE.md in your Claude workflow and start with prompt-engineer" }
  "github" { Write-Host "5. Open GitHub Copilot Chat and use .github/copilot-instructions.md plus prompt-engineer" }
}
