---
name: wacli
description: >
  Send WhatsApp messages to third parties or sync/search WhatsApp chat history via wacli CLI.
  Use only when user explicitly asks to message someone on WhatsApp or sync/search history.
  Not for normal chat conversations — WhatsApp routing is handled by the platform.
---

# wacli

WhatsApp CLI for sending messages and syncing/searching chat history. Use only when user explicitly asks to message someone on WhatsApp or sync/search history. Do NOT use for normal user chats.

## Setup

```bash
brew install steipete/tap/wacli
# OR
go install github.com/steipete/wacli/cmd/wacli@latest
```

Auth:
```bash
wacli auth          # QR login + initial sync
wacli sync --follow # continuous sync (background)
wacli doctor        # check setup health
```

Store dir: `~/.wacli` (override with `--store`).

## Safety

- Require explicit recipient + message text before sending.
- Confirm recipient + message before executing send.
- If anything ambiguous, ask clarifying question. Never guess recipient.

## Find Chats & Messages

```bash
# List chats (recent first, filtered by name/number)
wacli chats list --limit 20 --query "name or number"

# Search messages
wacli messages search "query" --limit 20 --chat <jid>
wacli messages search "invoice" --after 2025-01-01 --before 2025-12-31
```

JID format: direct chats = `<number>@s.whatsapp.net`, groups = `<id>@g.us`. Use `wacli chats list` to find JIDs.

## History Backfill

```bash
wacli history backfill --chat <jid> --requests 2 --count 50
```

Backfill requires phone online; results are best-effort.

## Send Messages

```bash
# Text to direct contact
wacli send text --to "+14155551212" --message "Hello! Are you free at 3pm?"

# Text to group
wacli send text --to "1234567890-123456789@g.us" --message "Running 5 min late."

# File with caption
wacli send file --to "+14155551212" --file /path/agenda.pdf --caption "Agenda"
```

## Store Lock

`wacli sync --follow` holds exclusive lock. Write commands (`send`, `history backfill`) fail while sync runs.

**To send while sync is active:**
```bash
kill $(wacli doctor --json | jq -r '.lock_info.pid')   # stop sync
wacli send text --to "..." --message "..."              # send
wacli sync --follow &                                    # restart sync
```

Read-only commands (`chats list`, `messages search`, `doctor`) work fine alongside sync.

## Tips

- Use `--json` for machine-readable output when parsing results.
- Store default path is `~/.wacli`; change with `--store` if needed.
- Backfill needs phone connected to internet.
