#!/bin/bash
set -euo pipefail

COMMIT="${1:-HEAD}"
PROMPT_FILE="${PROMPT_FILE:-ralph/ralph-review-prompt.md}"
# MODEL="${MODEL:-openai-codex/gpt-5.4:xhigh}"
MODEL="${MODEL:-zai/glm-5.1:high}"

if [ ! -f "$PROMPT_FILE" ]; then
  echo "[RALPH-REVIEW] ERROR: Review prompt not found: $PROMPT_FILE"
  exit 1
fi

echo "[RALPH-REVIEW] Started at $(date '+%H:%M:%S') — commit ${COMMIT:0:9}"

commit_hash=$(git rev-parse "$COMMIT")
commit_subject=$(git log -1 --format="%s" "$COMMIT")
commit_message=$(git log -1 --format="%B" "$COMMIT")
commit_stat=$(git show --stat --oneline "$COMMIT")
commit_diff=$(git show --find-renames --find-copies "$COMMIT")
review_prompt=$(cat "$PROMPT_FILE")

issue_number=$(
  echo "$commit_message" \
    | grep -Eo 'Issue: #[0-9]+' \
    | grep -Eo '[0-9]+' \
    | head -1 || true
)

if [ -z "$issue_number" ]; then
  echo "[RALPH-REVIEW] ERROR: Issue number not found in commit message."
  echo "[RALPH-REVIEW] Expected a line like: Issue: #123"
  echo "[RALPH-REVIEW] Commit message was:"
  echo "$commit_message"
  exit 1
fi

echo "[RALPH-REVIEW] Issue: #${issue_number}"

issue_json=$(
  gh issue view "$issue_number" \
    --json number,title,state,body,comments,labels \
    2>/dev/null || echo "{}"
)

pi --model "$MODEL" -p <<__PI_RALPH_REVIEW_PROMPT__ 2>&1 | sed $'s/\r//g; s/\x1b\\[[0-9;]*[A-Za-z]//g'
<review_target>
$commit_hash
</review_target>

<original_issue_number>
#$issue_number
</original_issue_number>

<original_issue>
$issue_json
</original_issue>

<commit_subject>
$commit_subject
</commit_subject>

<commit_message>
$commit_message
</commit_message>

<commit_stat>
$commit_stat
</commit_stat>

<commit_diff>
$commit_diff
</commit_diff>

<instructions>
$review_prompt
</instructions>
__PI_RALPH_REVIEW_PROMPT__

echo "[RALPH-REVIEW] Finished at $(date '+%H:%M:%S')"
