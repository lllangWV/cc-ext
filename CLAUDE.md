# Claude Code Extensions

This repository is a Claude Code plugin marketplace containing a curated collection of skills, agents, and slash commands.

## Project Structure

```
cc-ext/
├── .claude-plugin/
│   └── marketplace.json    # Marketplace manifest
├── plugins/
│   └── cc-ext/             # Main plugin
│       ├── .claude-plugin/
│       │   └── plugin.json # Plugin manifest
│       ├── agents/         # 6 custom subagents
│       ├── commands/       # 29 slash commands
│       └── skills/         # 25 skills
├── .claude/
│   ├── scripts/            # Utility scripts (hack/, ralph/)
│   └── settings.json       # Project configuration
└── README.md
```

## Key Patterns

### Skills
- Each skill lives in `plugins/cc-ext/skills/<name>/SKILL.md`
- Skills auto-activate based on their `description` field
- Supporting files go in the skill directory (scripts/, references/, etc.)

### Slash Commands
- Commands are `.md` files in `plugins/cc-ext/commands/`
- Use `$ARGUMENTS` or `$1`, `$2` for parameters
- Commands support `allowed-tools` to restrict tool access

### Agents
- Agents are `.md` files in `plugins/cc-ext/agents/`
- Define `tools`, `model`, and system prompt in frontmatter
- Used via Task tool for isolated execution

## Development Notes

- Test all changes with Claude Code before committing
- Update README.md when adding new extensions
- Follow existing naming conventions
- Keep descriptions concise but descriptive
