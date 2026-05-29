#!/bin/bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <iterations>"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AFK_SCRIPT="$SCRIPT_DIR/ralph-afk.sh"
REVIEW_SCRIPT="$SCRIPT_DIR/ralph-review.sh"

MAX_RETRIES="${MAX_RETRIES:-3}"
RETRY_SLEEP_SECONDS="${RETRY_SLEEP_SECONDS:-10}"

run_with_retry() {
  local command_name="$1"
  shift

  local attempt=1

  while true; do
    set +e
    "$@"
    status=$?
    set -e

    if [ "$status" -eq 0 ]; then
      return 0
    fi

    # 10 means Ralph found <promise>NO MORE TASKS</promise>.
    # Do not retry. Return it to the loop.
    if [ "$status" -eq 10 ]; then
      return 10
    fi

    if [ "$attempt" -ge "$MAX_RETRIES" ]; then
      echo "[RALPH-LOOP] ${command_name} failed after ${attempt} attempt(s)."
      return "$status"
    fi

    echo "[RALPH-LOOP] ${command_name} failed (status ${status}) — retrying in ${RETRY_SLEEP_SECONDS}s [attempt $((attempt + 1))/${MAX_RETRIES}]"

    sleep "$RETRY_SLEEP_SECONDS"
    attempt=$((attempt + 1))
  done
}

for ((i=1; i<=$1; i++)); do
  echo
  echo "[RALPH-LOOP] ── [${i}/${1}] $(date '+%H:%M:%S') ──────────────────────────────────────"

  before_commit=$(git rev-parse HEAD 2>/dev/null || echo "")

  set +e
  run_with_retry "afk" "$AFK_SCRIPT" 1
  ralph_status=$?
  set -e

  if [ "$ralph_status" -eq 10 ]; then
    echo "[RALPH-LOOP] No more tasks."
    exit 0
  fi

  if [ "$ralph_status" -ne 0 ]; then
    echo "[RALPH-LOOP] ERROR: Afk failed (status ${ralph_status})."
    exit "$ralph_status"
  fi

  after_commit=$(git rev-parse HEAD 2>/dev/null || echo "")

  if [[ "$before_commit" == "$after_commit" ]]; then
    echo "[RALPH-LOOP] No commit — skipping review."
    continue
  fi

  after_subject=$(git log -1 --format="%s" "$after_commit" 2>/dev/null || echo "(unknown)")
  echo "[RALPH-LOOP] Commit ${after_commit:0:9}  ${after_subject}"

  set +e
  run_with_retry "review" "$REVIEW_SCRIPT" "$after_commit"
  review_status=$?
  set -e

  if [ "$review_status" -ne 0 ]; then
    echo "[RALPH-LOOP] Review failed (status ${review_status}) — continuing."
  fi
done