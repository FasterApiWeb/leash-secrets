# Installation

## One-Command Installer

The fastest way to install leash. Detects every agent on your machine and installs for each.

=== "macOS / Linux / WSL / Git Bash"

    ```bash
    curl -fsSL https://raw.githubusercontent.com/FasterApiWeb/leash/main/scripts/install.sh | bash
    ```

=== "Windows PowerShell 5.1+"

    ```powershell
    irm https://raw.githubusercontent.com/FasterApiWeb/leash/main/scripts/install.ps1 | iex
    ```

~15 seconds. Skips agents you don't have. Safe to re-run.

### Installer Options

```bash
# Install for a specific agent only
curl -fsSL .../install.sh | bash -s -- --only cursor

# Uninstall
curl -fsSL .../install.sh | bash -s -- --uninstall
```

---

## Per-Agent Installation

### Cursor

Copy the rule file to your project or global rules:

```bash
# Project-level (recommended)
mkdir -p .cursor/rules
cp .cursor/rules/leash.mdc your-project/.cursor/rules/

# Global (all projects)
cp .cursor/rules/leash.mdc ~/.cursor/rules/
```

### Claude Code

```bash
# As a skill
mkdir -p ~/.claude/skills
cp skills/leash.md ~/.claude/skills/

# Or append to your project's CLAUDE.md
cat AGENTS.md >> your-project/CLAUDE.md
```

### Codex

```bash
# Global
cp AGENTS.md ~/.codex/AGENTS.md

# Project-level
cp AGENTS.md your-project/AGENTS.md
```

### GitHub Copilot

```bash
# Project-level
mkdir -p .github
cp .github/copilot-instructions.md your-project/.github/

# Global
cp .github/copilot-instructions.md ~/.copilot/copilot-instructions.md
```

### Gemini CLI

```bash
gemini extensions install https://github.com/FasterApiWeb/leash
```

### Windsurf

```bash
mkdir -p .windsurf/rules
cp skills/leash.md your-project/.windsurf/rules/leash.md
```

### Cline

```bash
mkdir -p .clinerules
cp skills/leash.md your-project/.clinerules/leash.md
```

### Kiro

```bash
mkdir -p .kiro/steering
cp skills/leash.md your-project/.kiro/steering/leash.md
```

### Any Agent That Reads `AGENTS.md`

```bash
cp AGENTS.md your-project/AGENTS.md
```

Works with: Aider, CodeWhale, Swival, VS Code + Codex extension, and many others.

---

## Via npm

```bash
npm install -g leash
```

This installs the pattern validation tools and gives you access to `npx leash` commands.

---

## Verify Installation

After installing, open your AI agent and type:

```
/leash
```

You should see the current mode (default: `patrol`). Try `/leash-help` for a quick reference.

---

## Uninstall

| Agent | Command |
|-------|---------|
| Cursor | Delete `.cursor/rules/leash.mdc` |
| Claude Code | Delete `~/.claude/skills/leash.md` |
| Codex | Remove leash section from `AGENTS.md` |
| Copilot | Delete `.github/copilot-instructions.md` |
| Gemini | `gemini extensions uninstall leash` |
| Windsurf / Cline / Kiro | Delete the copied rule file |
| Git hook | Delete `.git/hooks/pre-commit-leash` |
