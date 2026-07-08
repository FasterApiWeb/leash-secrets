# Agent Portability

Leash works with any AI coding agent that supports custom instructions, rules, or skills. Here's the mapping:

## Agent → File Matrix

| Agent | File | Path | Method |
|-------|------|------|--------|
| **Cursor** | `leash.mdc` | `.cursor/rules/leash.mdc` | Always-apply rule |
| **Claude Code** | `leash.md` | `~/.claude/skills/leash.md` or project `CLAUDE.md` | Skill or project doc |
| **Codex** | `AGENTS.md` | `~/.codex/AGENTS.md` or project root | Agent instructions |
| **GitHub Copilot** | `copilot-instructions.md` | `.github/copilot-instructions.md` | Copilot custom instructions |
| **Gemini CLI** | Extension | `gemini extensions install` | CLI extension |
| **Windsurf** | `leash.md` | `.windsurf/rules/leash.md` | Rule file |
| **Cline** | `leash.md` | `.clinerules/leash.md` | Rule file |
| **Kiro** | `leash.md` | `.kiro/steering/leash.md` | Steering file |
| **Aider** | `AGENTS.md` | Project root | Convention |
| **CodeWhale** | `AGENTS.md` | Project root | Convention |
| **Swival** | `AGENTS.md` | Project root or `~/.config/swival/` | Convention |
| **VS Code + Codex** | `AGENTS.md` | Project root or `~/.codex/` | Convention |
| **OpenClaw** | `leash.md` | `.openclaw/skills/` | Skill |

## Universal Compatibility

For agents not listed above, `AGENTS.md` is the universal fallback. Most modern AI coding agents read `AGENTS.md` from the project root. Copy it there and leash works.

## Global vs Project-Level

| Scope | When to use | How |
|-------|-------------|-----|
| **Global** | Every project on your machine | Copy to agent's global config directory (see paths above with `~/`) |
| **Project** | Specific project only | Copy to project root or project's agent config directory |
| **Both** | Recommended | Global for personal projects, project-level for team repos |

## What Each File Contains

All files contain the same core Leash Protocol, adapted to each agent's format:

- **`.mdc` files** (Cursor): Include frontmatter with `alwaysApply: true` and glob patterns
- **`.md` files** (most agents): Markdown with the protocol, patterns, and commands
- **`AGENTS.md`**: Compact version of the protocol for agents that read project-root instructions
- **Extensions** (Gemini): Package format wrapping the skill files

The core detection logic is identical across all formats. Only the delivery mechanism differs.
