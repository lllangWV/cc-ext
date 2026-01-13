# Ralph Implementation Loop

## Configuration
Check for `ralph.conf.json` in the project root or `scripts/` directory. If not found, use these defaults:
- Specs file: `specs/README.md`
- Source directories: `src/`
- Issues directory: `known-issues/`

## Pre-flight: Sync GitHub Issues (if enabled)

-1a. Detect the GitHub repository from git remote:
```bash
# Get GitHub owner/repo from remote URL
GITHUB_REPO=$(git remote get-url origin 2>/dev/null | sed -E 's|.*github\.com[:/]([^/]+/[^/.]+)(\.git)?|\1|')
echo "Detected repo: $GITHUB_REPO"
```

-1b. List open issues and compare with known-issues/:
```bash
# List issue numbers from GitHub (replace $GITHUB_REPO with detected value)
curl -s "https://api.github.com/repos/$GITHUB_REPO/issues?state=open" | jq -r '.[].number'

# List existing known-issues files
ls known-issues/ 2>/dev/null || mkdir -p known-issues/
```

-1c. For any issues on GitHub not in known-issues/, fetch and save:
```bash
# Fetch issue #N and save as markdown (replace N with issue number)
curl -s "https://api.github.com/repos/$GITHUB_REPO/issues/N" | \
  jq -r '"# \(.title)\n\n**Issue:** [#\(.number)](\(.html_url))\n**Author:** \(.user.login)\n**Created:** \(.created_at[:10])\n**State:** \(.state)\n\n\(.body)"' \
  > known-issues/issue-N.md
```

-1d. Read any new issues in known-issues/ and incorporate them into IMPLEMENTATION_PLAN.md

## Phase 0: Context Gathering

0a. Read the project specifications from `specs/README.md` (or configured specs file)

0b. Familiarize yourself with the source code structure

0c. Read IMPLEMENTATION_PLAN.md if it exists

## Phase 1: Implementation

1. Read IMPLEMENTATION_PLAN.md and implement the single highest priority feature using up to 5 subagents

2. After implementing, run the project's test and lint commands (check CLAUDE.md or package.json/pyproject.toml for commands), then update IMPLEMENTATION_PLAN.md with your progress

3. Commit changes:
```bash
git add -A && git commit -m "..."  # do not include claude attribution
```

## Guidelines

- Keep IMPLEMENTATION_PLAN.md up to date with progress
- Update CLAUDE.md when you learn new build/test commands
- Document bugs in IMPLEMENTATION_PLAN.md even if unrelated to current work
- Implement features fully - no placeholders or minimal implementations
