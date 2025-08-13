Param(
  [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$source = Join-Path $root 'AGENTS.md'

if (-not (Test-Path -Path $source -PathType Leaf)) {
  Write-Error "Source file not found: $source"
  exit 1
}

$content = Get-Content -Raw -Path $source

# Target files to keep in sync across different coding agent systems
$targetNames = @(
  '.cursorrules',   # Cursor
  'GEMINI.md',      # Gemini
  'CLAUDE.md',      # Claude
  'QWEN.md',        # Qwen
  'CODEX.md',       # Codex
  'OPENCODE.md'     # OpenCode
)

function Sync-File([string]$path) {
  if ($DryRun) {
    Write-Host "Would sync -> $path"
  } else {
    # Ensure directory exists
    $dir = Split-Path -Parent $path
    if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    # Write content
    Set-Content -Path $path -Value $content -Encoding UTF8
    Write-Host "Synced -> $path"
  }
}

# 1) Ensure root-level targets exist and are synced
foreach ($name in $targetNames) {
  $targetPath = Join-Path $root $name
  Sync-File $targetPath
}

Write-Host "Done."


