---
name: umami-stats
description: Query Umami analytics data via API (Cloud or self-hosted). Use when agents need website traffic, pages, events, sessions, realtime, reports, or attribution data for analysis, planning, experiments, or monitoring.
---

# Umami Stats (Read-only API skill)

Use this skill as a **data-access layer**: fetch Umami analytics data, then let the agent decide analysis/strategy.

---

## Setup

### Self-hosted (JWT auth)

Self-hosted Umami uses username/password login instead of API keys.

**1. Generate token:**
```bash
python3 scripts/umami_login.py \
  "https://analytics.carbos.app" \
  "your-username" \
  "your-password"
```

This saves the JWT token to `~/.umami_token` (mode 600).

**2. Set environment variables:**
```bash
export UMAMI_BASE_URL="https://analytics.carbos.app"
export UMAMI_DEPLOYMENT="self-hosted"
export UMAMI_TOKEN_FILE="$HOME/.umami_token"
```

**3. Query data:**
```bash
python3 scripts/umami_query.py \
  --endpoint /api/websites/{websiteId}/stats \
  --preset last7d
```

### Umami Cloud (API key auth)

**1. Set environment variables:**
```bash
export UMAMI_API_KEY="your-api-key"
export UMAMI_BASE_URL="https://api.umami.is"  # default
export UMAMI_DEPLOYMENT="cloud"
```

**2. Query data:**
```bash
python3 scripts/umami_query.py \
  --endpoint /v1/websites/{websiteId}/stats \
  --preset last7d
```

---

## Environment variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `UMAMI_BASE_URL` | No | `https://api.umami.is` | API base URL |
| `UMAMI_DEPLOYMENT` | No | `cloud` | `cloud` or `self-hosted` |
| `UMAMI_API_KEY` | Cloud: yes | - | API key for Umami Cloud |
| `UMAMI_TOKEN_FILE` | Self-hosted: auto | `~/.umami_token` | Path to JWT token file |
| `UMAMI_WEBSITE_ID` | No | - | Default website ID for queries |

---

## Workflow

1. Pick endpoint from `references/read-endpoints.md` or Umami docs.
2. Run `scripts/umami_query.py` with endpoint + params.
3. Use presets (`today`, `last7d`, `last30d`, etc.) or custom `startAt`/`endAt`.
4. Analyze returned JSON for the user task.

---

## Quick commands

```bash
# List all websites
python3 scripts/umami_query.py --endpoint /api/websites

# Stats for last 7 days
python3 scripts/umami_query.py \
  --endpoint /api/websites/{websiteId}/stats \
  --preset last7d

# Top pages (last 30 days)
python3 scripts/umami_query.py \
  --endpoint /api/websites/{websiteId}/pageviews \
  --preset last30d

# Events with custom time window
python3 scripts/umami_query.py \
  --endpoint /api/websites/{websiteId}/events/series \
  --param startAt=1738368000000 \
  --param endAt=1738972799000

# Metrics (requires type param)
python3 scripts/umami_query.py \
  --endpoint /api/websites/{websiteId}/metrics \
  --param type=url \
  --preset last7d
```

---

## Token refresh

JWT tokens expire (~30 days). When queries fail with 401:

```bash
python3 scripts/umami_login.py \
  "https://analytics.carbos.app" \
  "your-username" \
  "your-password"
```

---

## Notes

- Requests are **read-only** (`GET` only).
- Prefer explicit time windows (`--preset` or `--param startAt/endAt`) for reproducibility.
- Self-hosted uses `/api/...` paths; Cloud uses `/v1/...` paths.
- The script auto-maps paths: `/v1/...` ↔ `/api/...` based on deployment mode.
- `metrics` endpoints require `type` param (auto-defaults to `type=url`).

---

## Resources

- Endpoint reference: `references/read-endpoints.md`
- Query helper: `scripts/umami_query.py`
- Login helper: `scripts/umami_login.py`
- Umami API docs: https://umami.is/docs/environment
