#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/prompt.md"

MODE="github"
ISSUES_DIR=""
ITERATIONS=50
SANDBOX_CONTAINER=""

usage() {
  cat <<'EOF'
Usage: afk-claude.sh [path-to-issues] [--iterations N]

Run Claude Code autonomously through a queue of issues.

If a .sandbox/Dockerfile exists in the current directory, runs inside a
Docker container with project-specific tooling. Otherwise runs locally.

Arguments:
  path-to-issues    Path to a directory of issue markdown files (local mode)
                    If omitted, uses GitHub issues (github mode)

Options:
  --iterations N    Maximum iterations (default: 50)
  -h, --help        Show this help message

Examples:
  afk-claude.sh ./prds/recurring-shifts-issues --iterations 10
  afk-claude.sh --iterations 5
EOF
  exit 0
}

cleanup() {
  if [[ -n "$SANDBOX_CONTAINER" ]]; then
    echo ""
    echo "Stopping sandbox container..."
    docker stop "$SANDBOX_CONTAINER" >/dev/null 2>&1 || true
    docker rm "$SANDBOX_CONTAINER" >/dev/null 2>&1 || true
  fi
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help) usage ;;
    --iterations)
      if [[ -z "${2:-}" ]] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
        echo "Error: --iterations requires a positive integer" >&2
        exit 1
      fi
      ITERATIONS="$2"
      shift 2
      ;;
    *)
      if [[ -d "$1" ]]; then
        MODE="local"
        ISSUES_DIR="$(cd "$1" && pwd)"
      else
        echo "Error: '$1' is not a directory" >&2
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ "$MODE" == "local" ]]; then
  md_count=$(find "$ISSUES_DIR" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')
  if [[ "$md_count" -eq 0 ]]; then
    echo "Error: No .md files found in $ISSUES_DIR" >&2
    exit 1
  fi
  echo "Mode: local ($md_count issues in $ISSUES_DIR)"
else
  if ! gh auth status &>/dev/null; then
    echo "Error: GitHub CLI not authenticated. Run 'gh auth login' first." >&2
    exit 1
  fi
  echo "Mode: github"
fi

USE_SANDBOX=false
if [[ -f ".sandbox/Dockerfile" ]]; then
  USE_SANDBOX=true

  if [[ ! -f ".sandbox/.env" ]]; then
    echo "Error: .sandbox/.env not found. Copy .sandbox/.env.example and fill in your tokens." >&2
    exit 1
  fi

  IMAGE_NAME="afk-sandbox-$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]')"
  SANDBOX_CONTAINER="${IMAGE_NAME}-$$"

  echo "Sandbox: building image '$IMAGE_NAME'..."
  docker build -t "$IMAGE_NAME" .sandbox/ -q

  echo "Sandbox: starting container '$SANDBOX_CONTAINER'..."
  docker run -d \
    --name "$SANDBOX_CONTAINER" \
    --env-file .sandbox/.env \
    -v "$(pwd):/workspace" \
    -w /workspace \
    "$IMAGE_NAME" >/dev/null

  trap cleanup EXIT
  echo "Sandbox: ready"
fi

if [[ -f ".sandbox/config.json" ]]; then
  config_iterations=$(jq -r '.defaultIterations // empty' .sandbox/config.json 2>/dev/null)
  if [[ -n "$config_iterations" ]] && [[ "$ITERATIONS" -eq 50 ]]; then
    ITERATIONS="$config_iterations"
  fi
fi

echo "Iterations: $ITERATIONS"
echo ""

stream_text='select(.type == "assistant").message.content[]? | select(.type == "text").text // empty | gsub("\n"; "\r\n") | . + "\r\n\n"'
final_result='select(.type == "result").result // empty'

run_claude() {
  local prompt="$1"

  if [[ "$USE_SANDBOX" == true ]]; then
    docker exec "$SANDBOX_CONTAINER" \
      claude \
      --dangerously-skip-permissions \
      --print \
      --verbose \
      --output-format stream-json \
      "$prompt"
  else
    claude \
      --dangerously-skip-permissions \
      --print \
      --verbose \
      --output-format stream-json \
      "$prompt"
  fi
}

for ((i=1; i<=ITERATIONS; i++)); do
  tmpfile=$(mktemp)
  trap "rm -f $tmpfile; cleanup" EXIT

  echo "======= ITERATION $i of $ITERATIONS ======="

  if [[ "$MODE" == "local" ]]; then
    context="MODE=local ISSUES_DIR=$ISSUES_DIR"
  else
    context="MODE=github"
  fi

  prompt="$(cat "$PROMPT_FILE")

---
$context"

  run_claude "$prompt" \
  | grep --line-buffered '^{' \
  | tee "$tmpfile" \
  | jq --unbuffered -rj "$stream_text"

  result=$(jq -r "$final_result" "$tmpfile")

  if [[ "$result" == *"ALL_ISSUES_COMPLETE"* ]]; then
    echo ""
    echo "All issues complete after $i iterations."
    exit 0
  fi

  if [[ "$result" == *"ALL_REMAINING_BLOCKED"* ]]; then
    echo ""
    echo "All remaining issues are blocked. Stopping after $i iterations."
    exit 0
  fi

  echo ""
done

echo "Reached iteration limit ($ITERATIONS). Some issues may remain."
