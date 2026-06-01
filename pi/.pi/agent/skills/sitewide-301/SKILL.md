---
name: sitewide-301
description: |
  Implement site-wide 301 redirects from trailing-slash to non-trailing-slash URLs.
  Audit all rel="canonical" tags for consistency, update internal links and sitemaps.
  Use when user asks about canonical URLs, trailing slashes, 301 redirects,
  URL structure cleanup, SEO URL audit, or standardizing URL format across a project.
---

# Site-Wide 301 Redirect Implementation

Standardize all canonical URLs to **no trailing slash** (except root `/`).
Enforce via 301 redirect + update all internal refs.

## Workflow

### 1. Audit canonical tags

```bash
grep -rn 'rel="canonical" href=' --include='*.templ' --include='*.go' \
  --include='*.html' | grep -oP 'href="[^"]*"' | sort -u
```

**Checklist per URL:** Uses `https://`? No trailing slash (exc root `/`)? Dynamic vars produce correct format?

### 2. Implement 301 redirect middleware

Pre/early middleware. Skip if `/` or no trailing slash. Strip slash, preserve query string, return 301.

Register **before** route matching (`e.Pre(...)` in Echo, `app.use(...)` top in Express).

See [REFERENCE.md](REFERENCE.md) for Go/Echo + Express + Nginx + SW snippets.

### 3. Update sitemap

Find sitemap generation code. Remove trailing slash from each URL (exc root). Match canonicals exactly.

### 4. Update internal links

```bash
grep -rnP 'href="[^"]*/"' --include='*.templ' --include='*.go' \
  --include='*.html' --include='*.py' --include='*.js' | \
  grep -v 'node_modules' | grep -v 'href="/"$' | grep -v '_test.go'
```

Also check: `og:url`, breadcrumb JSON-LD, nav/footer, related cards, `llms.txt`.

If link was to index page (e.g. `/calculadoras/`), update both link and route. If link becomes invalid after slash removal (e.g. `/:tool/` but route needs `/:tool/:variant`), fix target URL.

### 5. Update routes

If route registered with trailing slash, change it. Middleware auto-redirects old URL via 301.

### 6. PWA service worker (optional)

Add client-side 301 to `fetch` handler. See [REFERENCE.md](REFERENCE.md).

### 7. Fix tests

Update: test request paths, expected strings, breadcrumb/SEO assertions.

### 8. Verify

```bash
go test -count=1 ./...

# No trailing-slash href remaining (except root /)
grep -rnP 'href="[^"]*/"' --include='*.go' --include='*.templ' \
  --include='*.html' | grep -v 'node_modules' | grep -v 'href="/"$' \
  | grep -v '_test.go' | grep -v 'rel="canonical"'

# No canonical URLs with trailing slash (except root)
grep -rn 'rel="canonical" href=' --include='*.go' --include='*.templ' \
  --include='*.html' | grep -oP 'href="[^"]*/"' | grep -v 'href="https://[^/]*/"'
```
