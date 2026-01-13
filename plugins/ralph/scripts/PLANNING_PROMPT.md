# Ralph Planning Loop

## Configuration
Check for `ralph.conf.json` in the project root or `scripts/` directory for project-specific settings.
Defaults: specs in `specs/README.md`, source in `src/`, issues in `known-issues/`

## Pre-flight: Sync GitHub Issues

-1a. Detect the GitHub repository from git remote:
```bash
GITHUB_REPO=$(git remote get-url origin 2>/dev/null | sed -E 's|.*github\.com[:/]([^/]+/[^/.]+)(\.git)?|\1|')
echo "Detected repo: $GITHUB_REPO"
```

-1b. List open issues and compare with known-issues/:
```bash
curl -s "https://api.github.com/repos/$GITHUB_REPO/issues?state=open" | jq -r '.[].number'
ls known-issues/ 2>/dev/null || mkdir -p known-issues/
```

-1c. For any issues on GitHub not in known-issues/, fetch and save:
```bash
# Replace N with issue number
curl -s "https://api.github.com/repos/$GITHUB_REPO/issues/N" | \
  jq -r '"# \(.title)\n\n**Issue:** [#\(.number)](\(.html_url))\n**Author:** \(.user.login)\n**Created:** \(.created_at[:10])\n**State:** \(.state)\n\n\(.body)"' \
  > known-issues/issue-N.md
```

-1d. Read any new issues in known-issues/

## Phase 0: Context Gathering

0a. Read the project specifications (default: `specs/README.md`)

0b. Read IMPLEMENTATION_PLAN.md if it exists to understand the plan so far

0c. Familiarize yourself with the source code structure

0d. Familiarize yourself with any examples/ directory if present

## Phase 1: Planning & Analysis

1. Study IMPLEMENTATION_PLAN.md (it may be incorrect) and use subagents to study existing source code, comparing it against the specifications. From that, create/update IMPLEMENTATION_PLAN.md as a bullet point list sorted by priority of items yet to be implemented. Think carefully and consider:
   - Searching for TODO comments
   - Finding minimal or placeholder implementations
   - Identifying gaps between specs and implementation

2. If examples/ exists, use subagents to study the examples and compare against specifications. Update IMPLEMENTATION_PLAN.md with any missing items.

3. Commit your changes:
```bash
git add -A && git commit -m "..."  # do not include claude attribution
```

## Important Guidelines

1. FOCUS ON ACCOMPLISHING THE PLANNING TASKS - do not get sidetracked

2. Avoid exploring these directories (they contain generated content):
   - `.pixi/`, `.venv/`, `node_modules/`
   - `.pytest_cache/`, `.ruff_cache/`, `__pycache__/`
   - `.devcontainer/`, `.config/`

3. When searching the codebase, focus on source directories (src/, test/, specs/, scripts/, examples/) and root-level files

4. Keep IMPLEMENTATION_PLAN.md up to date with items marked complete/incomplete using subagents
