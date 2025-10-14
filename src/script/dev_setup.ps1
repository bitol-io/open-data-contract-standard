#!/usr/bin/env pwsh
<#
.SYNOPSIS
  Developer environment setup (PowerShell 7+)
.DESCRIPTION
  Creates/activates venv (where possible), checks/updates pip and pre-commit,
  and Asserts config files (.pre-commit-config.yaml, .markdownlint.json, .commitlintrc.json).
#>

# -----------------------------
# 🎨 Color map & helpers
# -----------------------------
$Colors = @{
  'Info'  = 'Cyan'
  'Task'  = 'Yellow'
  'Pass'  = 'Green'
  'Warn'  = 'Magenta'
  'Fail'  = 'Red'
}

function Write-Info([string]$m){Write-Host "💡 [INFO]   $m" -ForegroundColor $Colors.Info }
function Write-Task([string]$m){ Write-Host "⚡ [TASK]   $m" -ForegroundColor $Colors.Task }
function Write-Pass([string]$m){ Write-Host "✅ [PASS]   $m" -ForegroundColor $Colors.Pass }
function Write-Warn([string]$m){ Write-Host "⚠️ [WARN]   $m" -ForegroundColor $Colors.Warn }
function Write-Fail([string]$m){ Write-Host "❌ [FAIL]   $m" -ForegroundColor $Colors.Fail }

# -----------------------------
# 🌱 Virtual environment
# -----------------------------
$VenvDir = ".venv"

function Assert-VirtualEnv {
  Write-Info "Checking virtual environment status ..."

  # PowerShell activation path (Windows & pwsh)
  $ActivatePs1 = Join-Path $VenvDir "Scripts/Activate.ps1"

  if (Test-Path $ActivatePs1) {
    if ($env:VIRTUAL_ENV) {
      Write-Pass "Virtual environment found and active."
    } else {
      Write-Info "Virtual environment found but not active."
      Write-Task "activating ..."
      try {
        & $ActivatePs1
      } catch {
        Write-Warn "Activation script ran but returned an error: $($_.Exception.Message)"
      }
    }
  } else {
    Write-Warn "No virtual environment found."
    Write-Task "creating and activating ..."
    try {
      & python -m venv $VenvDir 2>&1 | Out-Null
      & $ActivatePs1
    } catch {
      Write-Fail "Failed to create virtual environment: $($_.Exception.Message)"
    }
  }
}

# -----------------------------
# 🔧 Pip version helpers (robust regex)
# -----------------------------
function Get-PipVersion {
  try {
    $out = & pip --version 2>&1
  } catch {
    return $null
  }
  $match = [regex]::Match($out, 'pip\s+(\d+(?:\.\d+)+)')
  if ($match.Success) { return $match.Groups[1].Value }
  return $null
}

function Get-LatestPipVersion {
  try {
    $dry = & python -m pip install --upgrade pip --dry-run 2>&1
  } catch {
    $dry = $null
  }
  if ($null -ne $dry) {
    # look for "pip-1.2.3" or parenthesized versions like "(1.2.3)"
    $m = [regex]::Match($dry, 'pip-?(\d+(?:\.\d+)*)')
    if ($m.Success) { return $m.Groups[1].Value }
    $m2 = [regex]::Match($dry, '\((\d+(?:\.\d+)*)\)')
    if ($m2.Success) { return $m2.Groups[1].Value }
  }
  return $null
}

function Assert-PipUpToDate {
  Write-Info "Checking pip version ..."
  $current = Get-PipVersion
  $latest  = Get-LatestPipVersion

  if (-not $current -or -not $latest) {
    Write-Warn "Could not determine pip versions (current: $current, latest: $latest). Skipping upgrade check."
    return
  }
  Write-Info "Current: $current | Latest: $latest"
  if ($current -eq $latest) {
    Write-Pass "pip is up to date."
  } else {
    Write-Warn "pip is outdated."
    Write-Task "upgrading ..."
    try { & python -m pip install --upgrade pip } catch { Write-Fail "pip upgrade failed: $($_.Exception.Message)" }
  }
}

# -----------------------------
# 🔄 pre-commit helpers (robust regex)
# -----------------------------
function Assert-PreCommitInstalled {
  Write-Info "Checking pre-commit installation ..."
  if (Get-Command pre-commit -ErrorAction SilentlyContinue) {
    Write-Pass "pre-commit is installed."
  } else {
    Write-Warn "pre-commit is missing."
    Write-Task "installing ..."
    try { & pip install pre-commit } catch { Write-Fail "Failed to install pre-commit: $($_.Exception.Message)"; return }
  }
}

function Get-PreCommitVersion {
  try { $out = & pre-commit --version 2>&1 } catch { return $null }
  $match = [regex]::Match($out, 'pre-commit\s+(\d+(?:\.\d+)*)')
  if ($match.Success) { return $match.Groups[1].Value }
  return $null
}

function Get-LatestPreCommitVersion {
  try { $dry = & pip install pre-commit --upgrade --dry-run 2>&1 } catch { $dry = $null }
  if ($null -ne $dry) {
    $m = [regex]::Match($dry, 'commit-?(\d+(?:\.\d+)*)')
    if ($m.Success) { return $m.Groups[1].Value }
    $m2 = [regex]::Match($dry, '\((\d+(?:\.\d+)*)\)')
    if ($m2.Success) { return $m2.Groups[1].Value }
  }
  return $null
}

function Assert-PreCommitUpToDate {
  Write-Info "Checking pre-commit version ..."
  $current = Get-PreCommitVersion
  $latest  = Get-LatestPreCommitVersion
  if (-not $current -or -not $latest) {
    Write-Warn "Could not determine pre-commit versions (current: $current, latest: $latest). Skipping upgrade check."
    return
  }
  Write-Info "Current: $current | Latest: $latest"
  if ($current -eq $latest) {
    Write-Pass "pre-commit is up to date."
  } else {
    Write-Warn "pre-commit is outdated."
    Write-Task "upgrading ..."
    try { & pip install --upgrade pre-commit } catch { Write-Fail "Failed to upgrade pre-commit: $($_.Exception.Message)" }
  }
}

# -----------------------------
# 📄 Config file creators (PowerShell-native)
# -----------------------------
function New-PreCommitConfig { @"
default_stages: [pre-commit, manual]

repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v6.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
        args: ["--unsafe"]
      - id: check-added-large-files

  - repo: https://github.com/tcort/markdown-link-check
    rev: v3.13.7
    hooks:
      - id: markdown-link-check
        args: [-q]

  - repo: https://github.com/igorshubovych/markdownlint-cli
    rev: v0.45.0
    hooks:
      - id: markdownlint
        args: ["--ignore", "CHANGELOG.md", "--fix"]
"@ | Out-File -FilePath ".pre-commit-config.yaml" -Encoding utf8 }

function New-MarkdownLintConfig { @"
{
  "comment": "Markdown Lint Rules",
  "default": true,
  "MD007": {"indent": 4},
  "MD013": false,
  "MD024": false,
  "MD025": {"front_matter_title": ""},
  "MD029": {"style": "one_or_ordered"},
  "MD033": false
}
"@ | Out-File -FilePath ".markdownlint.json" -Encoding utf8 }

function New-CommitLintConfig { @"
{
  "rules": {
    "body-leading-blank": [1, "always"],
    "footer-leading-blank": [1, "always"],
    "header-max-length": [2, "always", 72],
    "scope-case": [2, "always", "upper-case"],
    "scope-empty": [2, "never"],
    "subject-case": [2, "never", ["start-case", "pascal-case", "upper-case"]],
    "subject-empty": [2, "never"],
    "subject-full-stop": [2, "never", "."],
    "type-case": [2, "always", "lower-case"],
    "type-empty": [2, "never"],
    "type-enum": [2, "always", ["build","chore","ci","docs","feat","fix","perf","refactor","revert","style","test"]]
  }
}
"@ | Out-File -FilePath ".commitlintrc.json" -Encoding utf8 }

# -----------------------------
# 🔧 Assert files and hooks
# -----------------------------
function Assert-File([string]$path, [scriptblock]$createBlock) {
  if (Test-Path $path) {
    Write-Pass "$path already exists, please ensure it has the correct format."
  } else {
    Write-Warn "$path file is missing."
    Write-Task "creating ..."
    & $createBlock
  }
}

function Assert-PreCommitHooks {
  Write-Info "Checking pre-commit config and hooks ..."
  Assert-File ".pre-commit-config.yaml" { New-PreCommitConfig }
  try {
    & pre-commit autoupdate
    & pre-commit install
  } catch {
    Write-Warn "pre-commit command failed to run: $($_.Exception.Message)"
  }

  # If commit-msg/commitlint present, install commit-msg hook and Assert commitlintrc
  $hasCommitMsg = Select-String -Path ".pre-commit-config.yaml" -Pattern "commit-msg|commitlint" -Quiet
  if ($hasCommitMsg) {
    Write-Task "Installing commit-msg hook ..."
    try {
      & pre-commit install --hook-type commit-msg
    } catch {
      Write-Warn "Could not install commit-msg hook: $($_.Exception.Message)"
    }
    Assert-File ".commitlintrc.json" { New-CommitLintConfig }
  }
  Assert-File ".markdownlint.json" { New-MarkdownLintConfig }
}

# -----------------------------
# 🚀 Run tasks
# -----------------------------
Assert-VirtualEnv
Assert-PipUpToDate
Assert-PreCommitInstalled
Assert-PreCommitUpToDate
Assert-PreCommitHooks

Write-Pass "🎉 Setup Completed Successfully!"
