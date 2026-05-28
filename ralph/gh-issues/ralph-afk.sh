#!/bin/bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <iterations>"
  exit 1
fi

GH_OPEN_ISSUE_LIMIT="${GH_OPEN_ISSUE_LIMIT:-200}"

fetch_open_issues() {
  gh issue list \
    --state open \
    --limit "$GH_OPEN_ISSUE_LIMIT" \
    --json number,title,body,comments,labels
}

classify_open_issues() {
  local issues_file="$1"

  python3 - "$issues_file" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    issues = json.load(f)


def lower(value):
    return (value or "").lower()


def label_names(issue):
    return [lower(label.get("name")) for label in issue.get("labels", [])]


def is_prd(issue):
    return (issue.get("title") or "").startswith("PRD:")


def is_hitl(issue):
    haystack = "\n".join([
        issue.get("title") or "",
        issue.get("body") or "",
        " ".join(label_names(issue)),
    ]).lower()
    return "hitl" in haystack


for issue in issues:
    if is_prd(issue):
        kind = "prd"
    elif is_hitl(issue):
        kind = "hitl"
    else:
        kind = "afk-executable"

    print(f"#{issue.get('number')} | {issue.get('title', '')} | {kind}")
PY
}

count_open_executable_issues() {
  local issues_file="$1"

  python3 - "$issues_file" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    issues = json.load(f)

count = 0
for issue in issues:
    title = issue.get("title") or ""
    body = issue.get("body") or ""
    labels = " ".join((label.get("name") or "") for label in issue.get("labels", []))
    haystack = f"{title}\n{body}\n{labels}".lower()

    if title.startswith("PRD:"):
        continue
    if "hitl" in haystack:
        continue

    count += 1

print(count)
PY
}

list_open_executable_issues() {
  local issues_file="$1"

  python3 - "$issues_file" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    issues = json.load(f)

for issue in issues:
    title = issue.get("title") or ""
    body = issue.get("body") or ""
    labels = " ".join((label.get("name") or "") for label in issue.get("labels", []))
    haystack = f"{title}\n{body}\n{labels}".lower()

    if title.startswith("PRD:"):
        continue
    if "hitl" in haystack:
        continue

    print(f"#{issue.get('number')} {title}")
PY
}

for ((i=1; i<=$1; i++)); do
  echo
  echo "Ralph iteration $i/$1 - Started at: $(date '+%Y-%m-%d %H:%M:%S')"
  echo

  tmpfile=$(mktemp)
  issues_file=$(mktemp)

  commits=$(git log -n 5 --format="%H%n%ad%n%B---" --date=short 2>/dev/null || echo "No commits found")
  fetch_open_issues > "$issues_file"
  issues=$(cat "$issues_file")
  classified_issues=$(classify_open_issues "$issues_file")
  prompt=$(cat ralph/ralph-afk-prompt.md)

  pi --model deepseek/deepseek-v4-flash:xhigh -p <<__PI_RALPH_PROMPT__ 2>&1 | tee "$tmpfile"
<recent_commits>
$commits
</recent_commits>

<classified_open_issues>
$classified_issues
</classified_open_issues>

<github_issues>
$issues
</github_issues>

<instructions>
$prompt
</instructions>
__PI_RALPH_PROMPT__

  result=$(cat "$tmpfile")
  rm -f "$tmpfile" "$issues_file"

  echo
  echo "Ralph iteration $i/$1 - Finished at: $(date '+%Y-%m-%d %H:%M:%S')"
  echo

  if [[ "$result" == *"<promise>NO MORE TASKS</promise>"* ]]; then
    remaining_issues_file=$(mktemp)
    fetch_open_issues > "$remaining_issues_file"
    remaining_executable_count=$(count_open_executable_issues "$remaining_issues_file")

    if [ "$remaining_executable_count" -gt 0 ]; then
      echo "Ralph claimed <promise>NO MORE TASKS</promise>, but $remaining_executable_count open executable issue(s) remain."
      echo "Remaining executable issues:"
      list_open_executable_issues "$remaining_issues_file"
      rm -f "$remaining_issues_file"
      exit 11
    fi

    rm -f "$remaining_issues_file"
    echo "Ralph complete after $i iterations."
    exit 10
  fi
done
