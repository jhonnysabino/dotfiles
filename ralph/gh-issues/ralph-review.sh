#!/bin/bash
set -euo pipefail

COMMIT="${1:-HEAD}"
PROMPT_FILE="${PROMPT_FILE:-ralph/ralph-review-prompt.md}"
# MODEL="${MODEL:-openai-codex/gpt-5.4:xhigh}"
MODEL="${MODEL:-zai/glm-5.1:high}"

if [ ! -f "$PROMPT_FILE" ]; then
  echo "Review prompt not found: $PROMPT_FILE"
  exit 1
fi

echo
echo "Ralph review - Started at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Reviewing commit: $COMMIT"
echo

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
  echo "Could not find issue number in commit message."
  echo "Expected commit body line like: Issue: #123"
  exit 1
fi

echo "Original issue: #$issue_number"
echo

issue_json=$(
  gh issue view "$issue_number" \
    --json number,title,state,body,comments,labels \
    2>/dev/null || echo "{}"
)

pi --model "$MODEL" -p <<__PI_RALPH_REVIEW_PROMPT__
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

echo
echo "Ralph review - Finished at: $(date '+%Y-%m-%d %H:%M:%S')"
echo
