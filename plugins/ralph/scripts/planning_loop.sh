#!/bin/bash
# Ralph planning loop
# Uses PLANNING_PROMPT.md for instructions (runs with opus for deeper analysis)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BRANCH=$(git rev-parse --abbrev-ref HEAD)

while true; do
    cat "$SCRIPT_DIR/PLANNING_PROMPT.md" | claude -p \
        --dangerously-skip-permissions \
        --output-format=stream-json \
        --model opus \
        --verbose \
        | bunx repomirror visualize
    git push origin "$BRANCH"
    echo -e "\n\n========================LOOP=========================\n\n"
done
