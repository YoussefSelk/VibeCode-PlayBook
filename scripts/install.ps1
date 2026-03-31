param(
  [string]$Destination = ".",
  [switch]$Force,
  [switch]$Backup,
  [string]$RepoBase = "https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main"
)

$ErrorActionPreference = "Stop"

$files = @(
  ".codex/config.toml",
  ".codex/agents/prompt-engineer.toml",
  ".codex/agents/db.toml",
  ".codex/agents/backend.toml",
  ".codex/agents/frontend.toml",
  ".codex/agents/tester.toml",
  ".codex/agents/reviewer.toml",
  "AGENTS.md",
  "agent_docs/README.md",
  "agent_docs/project_brief.md",
  "agent_docs/tech_stack.md",
  "agent_docs/active_context.md",
  "agent_docs/verification.md",
  "agent_docs/decisions.md"
)

function Save-Backup {
  param(
    [string]$PathToBackup
  )

  $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $backupPath = "$PathToBackup.bak.$timestamp"
  Copy-Item -LiteralPath $PathToBackup -Destination $backupPath -Force
  return $backupPath
}

$resolvedDestination = Resolve-Path -LiteralPath $Destination -ErrorAction SilentlyContinue
if (-not $resolvedDestination) {
  New-Item -ItemType Directory -Path $Destination -Force | Out-Null
  $resolvedDestination = Resolve-Path -LiteralPath $Destination
}

$targetRoot = $resolvedDestination.Path

Write-Host "Installing VibeCode PlayBook into $targetRoot"

$downloaded = 0
$skipped = 0
$backedUp = 0

foreach ($relativePath in $files) {
  $targetPath = Join-Path $targetRoot $relativePath
  $targetDir = Split-Path -Parent $targetPath

  if (-not (Test-Path -LiteralPath $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
  }

  if ((Test-Path -LiteralPath $targetPath) -and (-not $Force)) {
    Write-Host "Skipping existing file: $relativePath"
    $skipped++
    continue
  }

  if ((Test-Path -LiteralPath $targetPath) -and $Force -and $Backup) {
    $backupPath = Save-Backup -PathToBackup $targetPath
    Write-Host "Backed up existing file: $relativePath -> $backupPath"
    $backedUp++
  }

  $url = "$RepoBase/$relativePath"
  $tempPath = "$targetPath.tmp"
  Write-Host "Fetching $relativePath"
  Invoke-WebRequest -Uri $url -OutFile $tempPath
  Move-Item -LiteralPath $tempPath -Destination $targetPath -Force
  $downloaded++
}

Write-Host ""
Write-Host "Install complete."
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
Write-Host "5. Start using prompt-engineer in your project"
