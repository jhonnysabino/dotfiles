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
      echo
      echo "$command_name failed after $attempt attempt(s)."
      return "$status"
    fi

    echo
    echo "$command_name failed with status $status."
    echo "Retrying $command_name in ${RETRY_SLEEP_SECONDS}s... attempt $((attempt + 1))/$MAX_RETRIES"
    echo

    sleep "$RETRY_SLEEP_SECONDS"
    attempt=$((attempt + 1))
  done
}

for ((i=1; i<=$1; i++)); do
  echo
  echo "========================================"
  echo "Ralph loop $i/$1"
  echo "Started at: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "========================================"
  echo

  before_commit=$(git rev-parse HEAD 2>/dev/null || echo "")

  set +e
  run_with_retry "Ralph" "$AFK_SCRIPT" 1
  ralph_status=$?
  set -e

  if [ "$ralph_status" -eq 10 ]; then
    echo
    echo "No more AFK tasks. Stopping Ralph loop."
    echo
    exit 0
  fi

  if [ "$ralph_status" -ne 0 ]; then
    echo
    echo "Ralph failed with status $ralph_status."
    echo
    exit "$ralph_status"
  fi

  after_commit=$(git rev-parse HEAD 2>/dev/null || echo "")

  if [[ "$before_commit" == "$after_commit" ]]; then
    echo
    echo "No new commit created. Skipping review."
    echo
    continue
  fi

  echo
  echo "Reviewing commit: $after_commit"
  echo

  set +e
  run_with_retry "Ralph review" "$REVIEW_SCRIPT" "$after_commit"
  review_status=$?
  set -e

  if [ "$review_status" -ne 0 ]; then
    echo
    echo "Review finished with status $review_status."
    echo "Continuing loop because review failures may reopen the issue for the next iteration."
    echo
  fi

  echo
  echo "Ralph loop $i/$1 - Finished at: $(date '+%Y-%m-%d %H:%M:%S')"
  echo
done