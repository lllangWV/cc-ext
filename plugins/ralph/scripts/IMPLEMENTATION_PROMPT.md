# Ralph Implementation Loop (Detailed)

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

-1d. Read any new issues in known-issues/ and incorporate them into IMPLEMENTATION_PLAN.md

## Phase 0: Context Gathering

0a. Read the project specifications (default: `specs/README.md`)

0b. Familiarize yourself with the source code

## Phase 1: Implementation

1. Read IMPLEMENTATION_PLAN.md and implement the single highest priority feature using up to 5 subagents, including anything in the out of scope / future work - that's now in scope!

2. After implementing functionality or resolving problems, run the project's verification commands. Check CLAUDE.md or the project's config files (package.json, pyproject.toml, Makefile, etc.) for the correct commands:
   - Typechecking (if applicable)
   - Testing
   - Linting

   Ensure all checks pass, then update IMPLEMENTATION_PLAN.md with your progress.

3. Commit your changes:
```bash
git add -A && git commit -m "..."  # do not include claude attribution
```

## Important Guidelines

1. When you learn something new about how to run the code, update CLAUDE.md using a subagent but keep it brief.

2. For any bugs you notice, document them in IMPLEMENTATION_PLAN.md to be resolved, even if unrelated to current work.

3. You may add extra logging if required to debug issues.

4. ALWAYS keep IMPLEMENTATION_PLAN.md up to date with your learnings using a subagent, especially after finishing your turn.

5. When IMPLEMENTATION_PLAN.md becomes large, periodically clean out completed items using a subagent.

6. DO NOT implement placeholder or minimal implementations. We want FULL implementations.

7. Do NOT place status report updates into CLAUDE.md - keep it focused on build/development instructions.

8. Keep CLAUDE.md up to date with information on how to build and test the project.
