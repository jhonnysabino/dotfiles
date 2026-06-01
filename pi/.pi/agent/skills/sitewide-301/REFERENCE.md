# Reference: Real Moedux Implementation

This file captures the real-world implementation on the Moedux project (Go + Echo + Templ).
Use as concrete reference when applying the skill.

## Canonical tag audit output

All hardcoded canonical URLs before/after:

```
# After fix — all without trailing slash (except root)
https://www.moedux.com/                   # root — OK
https://www.moedux.com/ajuda              # OK
https://www.moedux.com/app/login          # OK
https://www.moedux.com/blog/*             # OK (24 posts)
https://www.moedux.com/calculadoras       # FIXED (was /calculadoras/)
https://www.moedux.com/calculators/*      # OK
https://www.moedux.com/cases/*            # OK
https://www.moedux.com/comparar           # OK
https://www.moedux.com/compare            # OK
https://www.moedux.com/demo               # OK
https://www.moedux.com/depoimentos        # OK
https://www.moedux.com/faq                # OK
https://www.moedux.com/ferramentas        # OK
https://www.moedux.com/guia               # OK
https://www.moedux.com/precos-alt         # OK
https://www.moedux.com/pricing            # OK
https://www.moedux.com/pricing/success    # OK
https://www.moedux.com/privacidade        # OK
https://www.moedux.com/sobre              # OK
https://www.moedux.com/termos             # OK
```

## Types of canonical declarations found

### 1. Static HTML in `.templ` files
```
<link rel="canonical" href="https://www.moedux.com/pricing"/>
```

### 2. Raw HTML strings in `.go` files
```go
var toolsHTML = `...<link rel="canonical" href="https://www.moedux.com/ferramentas"/>...`
```

### 3. Dynamic via template variable
```templ
<link rel="canonical" href={ post.CanonicalURL }/>
```

```templ
<link rel="canonical" href={ meta.Canonical }/>
```

### 4. Generated `_templ.go` files
Templ generates `_templ.go` from `.templ`. Edit the `.templ` source, then run:
```bash
templ generate
```

## Breadcrumb schema JSON-LD

Before:
```go
"item":"https://www.moedux.com/calculadoras/"
"item":"https://www.moedux.com/calculadoras/%s/"
```

After:
```go
"item":"https://www.moedux.com/calculadoras"
"item":"https://www.moedux.com/calculadoras/%s"
```

## Sitemap URLs

Before:
```go
{"https://www.moedux.com/calculadoras/", "0.8", "monthly"},
```

After:
```go
{"https://www.moedux.com/calculadoras", "0.8", "monthly"},
```

## Route change

Before: `e.GET("/calculadoras/", h.IndexPage)`
After:  `e.GET("/calculadoras", h.IndexPage)`

Middleware handles redirect from old path.

## Internal links found to fix

| Location | Before | After |
|----------|--------|-------|
| Tool breadcrumb | `href="/calculadoras/"` | `href="/calculadoras"` |
| Related tools | `href="/calculadoras/:tool/"` | `href="/calculadoras/:tool"` |
| Tool index cards | `href="/calculadoras/:tool/"` | `href="/calculadoras/:tool/:variant"` |
| `llms.txt` | `https://.../calculadoras/` | `https://.../calculadoras` |
| `llms-full.txt` | `https://.../calculadoras/` | `https://.../calculadoras` |

## 301 redirect middleware (Go/Echo)

```go
package middleware

import (
	"net/http"
	"strings"

	"github.com/labstack/echo/v4"
)

func TrailingSlashRedirectMiddleware() echo.MiddlewareFunc {
	return func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			path := c.Request().URL.Path
			if path == "/" || !strings.HasSuffix(path, "/") {
				return next(c)
			}
			canonicalPath := strings.TrimRight(path, "/")
			if canonicalPath == "" {
				canonicalPath = "/"
			}
			if rawQuery := c.Request().URL.RawQuery; rawQuery != "" {
				canonicalPath += "?" + rawQuery
			}
			return c.Redirect(http.StatusMovedPermanently, canonicalPath)
		}
	}
}
```

Register as Pre middleware (before route matching):
```go
e.Pre(mw.TrailingSlashRedirectMiddleware())
```

## 301 redirect middleware (Express/Node)

```js
app.use((req, res, next) => {
  if (req.path === '/' || !req.path.endsWith('/')) return next();
  const query = req.url.includes('?') ? req.url.substring(req.url.indexOf('?')) : '';
  res.redirect(301, req.path.replace(/\/+$/, '') + query);
});
```

## 301 redirect (Nginx)

```nginx
rewrite ^/(.*)/$ /$1 permanent;
```

## Service Worker client-side redirect

```js
// In fetch handler — before other logic
if (request.mode === 'navigate' && url.pathname.length > 1 && url.pathname.endsWith('/')) {
  const canonicalURL = new URL(request.url);
  canonicalURL.pathname = canonicalURL.pathname.replace(/\/+$/, '');
  event.respondWith(Promise.resolve(Response.redirect(canonicalURL.toString(), 301)));
  return;
}
```

## Test files updated

| Test file | What changed |
|-----------|-------------|
| `pseo/pseo_audit_test.go` | Breadcrumb assertion: `href="/calculadoras/"` → `href="/calculadoras"` |
| `seo/seo_audit_test.go` | Static URL list, llms.txt assertions |
| `seo/preconnect_test.go` | Test path `/calculadoras/` → `/calculadoras` |
| `llmstxt/llmstxt_test.go` | Expected URLs in llms.txt content |
