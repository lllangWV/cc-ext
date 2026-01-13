#!/bin/bash
# Ralph detailed implementation loop
# Uses IMPLEMENTATION_PROMPT.md for instructions

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BRANCH=$(git rev-parse --abbrev-ref HEAD)

while true; do
    cat "$SCRIPT_DIR/IMPLEMENTATION_PROMPT.md" | claude -p \
        --dangerously-skip-permissions \
        --output-format=stream-json \
        --model sonnet \
        --verbose \
        | bunx repomirror visualize
    git push origin "$BRANCH"
    echo -e "\n\n========================LOOP=========================\n\n"
done
