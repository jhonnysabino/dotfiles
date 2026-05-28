---
name: gstack-setup-browser-cookies
description: |
  Import cookies from your real Chromium browser into the headless browse session. Opens
  an interactive picker UI where you select which cookie domains to import. Use before QA
  testing authenticated pages. Use when asked to "import cookies", "login to the site", or
  "authenticate the browser". (gstack-setup-browser-cookies)
---

# gstack-setup-browser-cookies — Importar cookies do navegador real

Importa sessões logadas do Chromium instalado na máquina pro headless browse.

Depende do **gstack-browse** — o binary já deve estar instalado em:

```bash
B=/home/jhonny/.pi/agent/skills/gstack-browse/browse/dist/browse
```

## Fluxo

### 1. Verificar se já não tá em modo CDP

```bash
$B status 2>/dev/null | grep -q "Mode: cdp" && echo "CDP_MODE=true" || echo "CDP_MODE=false"
```

Se `CDP_MODE=true`: avisar "Não precisa — já conectado no seu navegador real via CDP." Parar.

### 2. Abrir o cookie picker

```bash
$B cookie-import-browser
```

Isso detecta os Chromium instalados e abre uma UI interativa no navegador.
O usuário vê os domínios e clica "+" pra importar.

**Avisar o usuário:** "Cookie picker aberto — seleciona os domínios no navegador e me avisa quando terminar."

### 3. Import direto (alternativa)

Se o domínio já é conhecido, pula a UI:

```bash
$B cookie-import-browser comet --domain github.com
```

### 4. Verificar

Depois do usuário confirmar:

```bash
$B cookies
```

Mostrar resumo (domínios importados).

## Notas

- **macOS:** primeira importação por browser pode pedir acesso ao Keychain — clicar "Allow"
- **Linux:** cookies `v11` podem precisar de `secret-tool`/libsecret
- A UI roda na mesma porta do servidor browse (sem processo extra)
- Só nomes de domínio e contagem de cookies aparecem na UI — valores nunca expostos
- Cookies persistem entre comandos na sessão headless
