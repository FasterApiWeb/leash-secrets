# ──────────────────────────────────────────
# leash installer — Windows PowerShell 5.1+
# ──────────────────────────────────────────

$ErrorActionPreference = "Stop"
$Version = "1.0.0"
$Repo = "FasterApiWeb/leash"
$Raw = "https://raw.githubusercontent.com/$Repo/main"

function Write-Banner {
    Write-Host ""
    Write-Host "  ┌─────────────────────────────────────┐" -ForegroundColor Cyan
    Write-Host "  │       🔒 leash installer v$Version       │" -ForegroundColor Cyan
    Write-Host "  │  keep your secrets on a leash       │" -ForegroundColor Cyan
    Write-Host "  └─────────────────────────────────────┘" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Info($msg)    { Write-Host "  → $msg" -ForegroundColor Cyan }
function Write-Ok($msg)      { Write-Host "  ✓ $msg" -ForegroundColor Green }
function Write-Warn($msg)    { Write-Host "  ⚠ $msg" -ForegroundColor Yellow }
function Write-Fail($msg)    { Write-Host "  ✗ $msg" -ForegroundColor Red }

Write-Banner

function Install-CursorRule {
    $dir = "$env:USERPROFILE\.cursor\rules"
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    try {
        Invoke-WebRequest -Uri "$Raw/.cursor/rules/leash.mdc" -OutFile "$dir\leash.mdc" -UseBasicParsing
        Write-Ok "Installed leash for Cursor → $dir\leash.mdc"
    } catch {
        Write-Fail "Could not install Cursor rule: $_"
    }
}

function Install-ClaudeSkill {
    $dir = "$env:USERPROFILE\.claude\skills"
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    try {
        Invoke-WebRequest -Uri "$Raw/skills/leash.md" -OutFile "$dir\leash.md" -UseBasicParsing
        Write-Ok "Installed leash for Claude Code → $dir\leash.md"
    } catch {
        Write-Fail "Could not install Claude Code skill: $_"
    }
}

function Install-CopilotInstructions {
    $dir = ".github"
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    try {
        Invoke-WebRequest -Uri "$Raw/.github/copilot-instructions.md" -OutFile "$dir\copilot-instructions.md" -UseBasicParsing
        Write-Ok "Installed leash for GitHub Copilot → $dir\copilot-instructions.md"
    } catch {
        Write-Fail "Could not install Copilot instructions: $_"
    }
}

Install-CursorRule
Install-ClaudeSkill
Install-CopilotInstructions

Write-Host ""
Write-Host "  leash installed." -ForegroundColor Green -NoNewline
Write-Host " Your secrets are on a leash."
Write-Host "  Type /leash in your agent to get started." -ForegroundColor Cyan
Write-Host ""
