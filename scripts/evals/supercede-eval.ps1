Param(
  [Parameter(Mandatory=$true)][string]$New,
  [Parameter(Mandatory=$true)][string]$Prev,
  [Parameter(Mandatory=$true)][ValidateSet('positive','negative','neutral')][string]$DeltaTrend
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Show-Error([string]$Message) {
  Write-Error $Message
  exit 1
}

if (-not (Test-Path -Path $New -PathType Leaf)) { Show-Error "New eval not found: $New" }
if (-not (Test-Path -Path $Prev -PathType Leaf)) { Show-Error "Previous eval not found: $Prev" }

function Assert-Frontmatter([string]$File) {
  $first = Get-Content -Path $File -TotalCount 1 -ErrorAction Stop
  if ($first -ne '---') { Show-Error "File missing YAML frontmatter (expected starting '---'): $File" }
}

Assert-Frontmatter -File $New
Assert-Frontmatter -File $Prev

function Set-Or-Insert-YamlKey([string]$File, [string]$Key, [string]$Value) {
  $lines = Get-Content -Path $File -Raw -ErrorAction Stop -Encoding UTF8
  # Identify first frontmatter block (supports LF and CRLF)
  $regex = [System.Text.RegularExpressions.Regex]::new("(?s)^---\s.*?[\r\n]---\s")
  $match = $regex.Match($lines)
  if (-not $match.Success) { Show-Error "Could not find YAML frontmatter closing delimiter in $File" }

  $fm = $match.Value
  $body = $lines.Substring($fm.Length)

  $pattern = "(?m)^$($Key):\s*.*$"
  if ([System.Text.RegularExpressions.Regex]::IsMatch($fm, $pattern)) {
    $fm = [System.Text.RegularExpressions.Regex]::Replace($fm, $pattern, "${Key}: ${Value}")
  } else {
    $fm = $fm.TrimEnd() + "`n${Key}: ${Value}`n"
  }

  $out = $fm + $body
  Set-Content -Path $File -Value $out -Encoding UTF8 -NoNewline
}

$today = Get-Date -Format 'yyyy-MM-dd'

# Update previous eval
Set-Or-Insert-YamlKey -File $Prev -Key 'status' -Value 'archived'
Set-Or-Insert-YamlKey -File $Prev -Key 'archived_at' -Value $today
Set-Or-Insert-YamlKey -File $Prev -Key 'superseded_by' -Value $New

# Update new eval
Set-Or-Insert-YamlKey -File $New -Key 'supersedes' -Value $Prev
Set-Or-Insert-YamlKey -File $New -Key 'delta_trend' -Value $DeltaTrend

# Move previous to archive/YYYY
$prevDir = Split-Path -Path $Prev -Parent
$prevBase = Split-Path -Path $Prev -Leaf
$year = ($prevBase -match '^(\d{4})') ? $Matches[1] : (Get-Date -Format 'yyyy')
$archiveDir = Join-Path $prevDir (Join-Path 'archive' $year)
New-Item -ItemType Directory -Force -Path $archiveDir | Out-Null
$target = Join-Path $archiveDir $prevBase
if (Test-Path -Path $target -PathType Leaf) { Show-Error "Archive target already exists: $target" }
Move-Item -Path $Prev -Destination $target

Write-Host "Archived previous eval to: $target"
Write-Host "Updated frontmatter on new eval: $New (supersedes, delta_trend=$DeltaTrend)"


