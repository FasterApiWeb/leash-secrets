#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────
# leash installer — macOS · Linux · WSL · Git Bash
# ──────────────────────────────────────────

VERSION="1.0.0"
REPO="FasterApiWeb/leash"
RAW="https://raw.githubusercontent.com/$REPO/main"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

banner() {
  echo ""
  echo -e "${CYAN}${BOLD}"
  echo "  ┌─────────────────────────────────────┐"
  echo "  │       🔒 leash installer v$VERSION       │"
  echo "  │  keep your secrets on a leash       │"
  echo "  └─────────────────────────────────────┘"
  echo -e "${NC}"
}

info()    { echo -e "  ${CYAN}→${NC} $1"; }
success() { echo -e "  ${GREEN}✓${NC} $1"; }
warn()    { echo -e "  ${YELLOW}⚠${NC} $1"; }
fail()    { echo -e "  ${RED}✗${NC} $1"; }

ONLY=""
UNINSTALL=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --only)      ONLY="$2"; shift 2 ;;
    --uninstall) UNINSTALL=true; shift ;;
    -h|--help)
      banner
      echo "  Usage: install.sh [--only <agent>] [--uninstall]"
      echo ""
      echo "  Agents: cursor, claude, codex, copilot, windsurf, cline, gemini, all"
      echo ""
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

banner

install_cursor() {
  local rules_dir
  if [[ -d ".cursor/rules" ]]; then
    rules_dir=".cursor/rules"
  else
    rules_dir="$HOME/.cursor/rules"
    mkdir -p "$rules_dir"
  fi

  if $UNINSTALL; then
    rm -f "$rules_dir/leash.mdc"
    success "Removed leash from Cursor"
    return
  fi

  curl -fsSL "$RAW/.cursor/rules/leash.mdc" -o "$rules_dir/leash.mdc" 2>/dev/null || \
    cp -f .cursor/rules/leash.mdc "$rules_dir/leash.mdc" 2>/dev/null || {
      fail "Could not install Cursor rule"; return
    }
  success "Installed leash for Cursor → $rules_dir/leash.mdc"
}

install_claude() {
  local claude_dir="$HOME/.claude/skills"
  mkdir -p "$claude_dir"

  if $UNINSTALL; then
    rm -f "$claude_dir/leash.md"
    success "Removed leash from Claude Code"
    return
  fi

  curl -fsSL "$RAW/skills/leash.md" -o "$claude_dir/leash.md" 2>/dev/null || \
    cp -f skills/leash.md "$claude_dir/leash.md" 2>/dev/null || {
      fail "Could not install Claude Code skill"; return
    }
  success "Installed leash for Claude Code → $claude_dir/leash.md"
}

install_codex() {
  local codex_dir="$HOME/.codex"
  mkdir -p "$codex_dir"

  if $UNINSTALL; then
    rm -f "$codex_dir/leash.md"
    success "Removed leash from Codex"
    return
  fi

  if [[ -f "$codex_dir/AGENTS.md" ]]; then
    if ! grep -q "leash" "$codex_dir/AGENTS.md" 2>/dev/null; then
      cat AGENTS.md >> "$codex_dir/AGENTS.md" 2>/dev/null || true
    fi
  else
    curl -fsSL "$RAW/AGENTS.md" -o "$codex_dir/AGENTS.md" 2>/dev/null || \
      cp -f AGENTS.md "$codex_dir/AGENTS.md" 2>/dev/null || true
  fi
  success "Installed leash for Codex → $codex_dir/AGENTS.md"
}

install_copilot() {
  local copilot_dir=".github"
  mkdir -p "$copilot_dir"

  if $UNINSTALL; then
    rm -f "$copilot_dir/copilot-instructions.md"
    success "Removed leash from GitHub Copilot"
    return
  fi

  curl -fsSL "$RAW/.github/copilot-instructions.md" -o "$copilot_dir/copilot-instructions.md" 2>/dev/null || \
    cp -f .github/copilot-instructions.md "$copilot_dir/copilot-instructions.md" 2>/dev/null || {
      fail "Could not install Copilot instructions"; return
    }
  success "Installed leash for GitHub Copilot → $copilot_dir/copilot-instructions.md"
}

install_windsurf() {
  local rules_dir=".windsurf/rules"
  mkdir -p "$rules_dir"

  if $UNINSTALL; then
    rm -f "$rules_dir/leash.md"
    success "Removed leash from Windsurf"
    return
  fi

  curl -fsSL "$RAW/skills/leash.md" -o "$rules_dir/leash.md" 2>/dev/null || \
    cp -f skills/leash.md "$rules_dir/leash.md" 2>/dev/null || {
      fail "Could not install Windsurf rule"; return
    }
  success "Installed leash for Windsurf → $rules_dir/leash.md"
}

install_cline() {
  local rules_dir=".clinerules"
  mkdir -p "$rules_dir"

  if $UNINSTALL; then
    rm -f "$rules_dir/leash.md"
    success "Removed leash from Cline"
    return
  fi

  curl -fsSL "$RAW/skills/leash.md" -o "$rules_dir/leash.md" 2>/dev/null || \
    cp -f skills/leash.md "$rules_dir/leash.md" 2>/dev/null || {
      fail "Could not install Cline rule"; return
    }
  success "Installed leash for Cline → $rules_dir/leash.md"
}

install_gemini() {
  if $UNINSTALL; then
    info "For Gemini, run: gemini extensions uninstall leash"
    return
  fi

  if command -v gemini &>/dev/null; then
    gemini extensions install "https://github.com/$REPO" 2>/dev/null && \
      success "Installed leash for Gemini CLI" || \
      warn "Could not auto-install for Gemini. Run: gemini extensions install https://github.com/$REPO"
  else
    warn "Gemini CLI not found. Install manually: gemini extensions install https://github.com/$REPO"
  fi
}

install_git_hooks() {
  if $UNINSTALL; then
    rm -f .git/hooks/pre-commit-leash
    success "Removed leash git hooks"
    return
  fi

  if [[ -d ".git" ]]; then
    curl -fsSL "$RAW/hooks/pre-commit.sh" -o ".git/hooks/pre-commit-leash" 2>/dev/null || \
      cp -f hooks/pre-commit.sh ".git/hooks/pre-commit-leash" 2>/dev/null || {
        warn "Could not install git pre-commit hook"; return
      }
    chmod +x ".git/hooks/pre-commit-leash"

    if [[ -f ".git/hooks/pre-commit" ]]; then
      if ! grep -q "pre-commit-leash" ".git/hooks/pre-commit" 2>/dev/null; then
        echo -e '\n# leash secret scanner\n.git/hooks/pre-commit-leash' >> .git/hooks/pre-commit
      fi
    else
      echo -e '#!/usr/bin/env bash\n# leash secret scanner\n.git/hooks/pre-commit-leash' > .git/hooks/pre-commit
      chmod +x .git/hooks/pre-commit
    fi
    success "Installed leash git pre-commit hook"
  else
    warn "Not a git repo — skipped pre-commit hook"
  fi
}

agents=("cursor" "claude" "codex" "copilot" "windsurf" "cline" "gemini")

if [[ -n "$ONLY" ]]; then
  agents=("$ONLY")
fi

for agent in "${agents[@]}"; do
  case "$agent" in
    cursor)   install_cursor ;;
    claude)   install_claude ;;
    codex)    install_codex ;;
    copilot)  install_copilot ;;
    windsurf) install_windsurf ;;
    cline)    install_cline ;;
    gemini)   install_gemini ;;
    all)
      install_cursor; install_claude; install_codex
      install_copilot; install_windsurf; install_cline; install_gemini
      ;;
    *) fail "Unknown agent: $agent" ;;
  esac
done

install_git_hooks

echo ""
if $UNINSTALL; then
  echo -e "  ${GREEN}${BOLD}leash removed.${NC} Your secrets are on their own now."
else
  echo -e "  ${GREEN}${BOLD}leash installed.${NC} Your secrets are on a leash."
  echo -e "  Type ${CYAN}/leash${NC} in your agent to get started."
fi
echo ""
