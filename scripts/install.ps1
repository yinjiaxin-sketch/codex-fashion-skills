$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$source = Join-Path $repoRoot "skills\image-edit-director"
$target = Join-Path $env:USERPROFILE ".codex\skills\image-edit-director"

if (-not (Test-Path -LiteralPath $source)) {
    throw "Skill source not found: $source"
}

$targetParent = Split-Path -Parent $target
New-Item -ItemType Directory -Force -Path $targetParent | Out-Null

if (Test-Path -LiteralPath $target) {
    Remove-Item -LiteralPath $target -Recurse -Force
}

Copy-Item -LiteralPath $source -Destination $target -Recurse -Force

Write-Host "Installed image-edit-director to: $target"
Write-Host "Restart Codex if the skill does not appear immediately."
