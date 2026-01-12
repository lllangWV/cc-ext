# Claude Code Extensions

This repository contains a curated collection of skills, agents, and slash commands for Claude Code.

## Project Structure

```
.claude/
├── agents/       # 6 custom subagents for specialized tasks
├── commands/     # 29 slash commands for common workflows
├── scripts/      # Utility scripts (hack/, ralph/)
├── skills/       # 25 skills for document handling, design, development
└── settings.json # Project configuration
```

## Key Patterns

### Skills
- Each skill lives in `.claude/skills/<name>/SKILL.md`
- Skills auto-activate based on their `description` field
- Supporting files go in the skill directory (scripts/, references/, etc.)

### Slash Commands
- Commands are `.md` files in `.claude/commands/`
- Use `$ARGUMENTS` or `$1`, `$2` for parameters
- Commands support `allowed-tools` to restrict tool access

### Agents
- Agents are `.md` files in `.claude/agents/`
- Define `tools`, `model`, and system prompt in frontmatter
- Used via Task tool for isolated execution

## Development Notes

- Test all changes with Claude Code before committing
- Update README.md when adding new extensions
- Follow existing naming conventions
- Keep descriptions concise but descriptive
