# Contributing to Claude Code Extensions

Thank you for your interest in contributing! This document provides guidelines for contributing to this collection of Claude Code extensions.

## How to Contribute

### Reporting Issues

- Use GitHub Issues to report bugs or suggest features
- Check existing issues before creating a new one
- Provide clear reproduction steps for bugs
- Include Claude Code version if relevant

### Adding New Skills

1. Create a new directory in `.claude/skills/your-skill-name/`
2. Add a `SKILL.md` file with proper frontmatter:

```markdown
---
name: your-skill-name
description: Brief description of when to use this skill
---

# Skill Name

## Instructions
Clear guidance for Claude...

## Examples
Concrete usage examples...
```

3. Include any supporting files (scripts, references, templates)
4. Test the skill in Claude Code before submitting
5. Update the README.md with the new skill

### Adding New Slash Commands

1. Create a new `.md` file in `.claude/commands/`
2. Use proper frontmatter:

```markdown
---
description: Brief description of the command
allowed-tools: Read, Grep, Glob  # Optional: limit available tools
---

Prompt instructions for Claude...
```

3. Test the command with `/command-name`
4. Update the README.md

### Adding New Agents

1. Create a new `.md` file in `.claude/agents/`
2. Define the agent with frontmatter:

```markdown
---
name: agent-name
description: When to use this agent
tools: Read, Grep, Glob, Bash
model: sonnet  # or haiku, opus
---

Agent system prompt...
```

3. Test the agent via the Task tool
4. Update the README.md

## Code Style

- Use clear, descriptive names for skills, commands, and agents
- Write concise but complete descriptions
- Include examples where helpful
- Follow existing patterns in the repository

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-skill`)
3. Make your changes
4. Test your changes with Claude Code
5. Update documentation (README.md)
6. Submit a pull request with a clear description

## Questions?

Open an issue for any questions about contributing.
