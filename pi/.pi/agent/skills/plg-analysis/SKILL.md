---
name: plg-analysis
description: Realiza análise completa de Product-Led Growth do repositório atual usando o framework das 7 Camadas (Aakash Gupta/Jaryd Hermann, 2026) mais os 4 vetores modernos (personalização, expansão organizacional, evolução do freemium, AI como infraestrutura). Avalia maturidade PLG por layer, identifica gargalos, fricções e oportunidades, e gera roadmap com top 5 melhorias e experimentos. Use quando usuário pedir "análise PLG", "product-led growth", "7 camadas", "avaliação de crescimento", "plg-audit" ou "maturidade PLG".
---

# PLG Analysis — 7-Layer Framework

## Quick start

1. Ler [ANALYSIS_TEMPLATE.md](ANALYSIS_TEMPLATE.md) — template obrigatório do relatório
2. Consultar wiki para contexto:
   - `/home/jhonny/llm-wiki/wiki/concepts/product-led-growth.md`
   - `/home/jhonny/llm-wiki/wiki/concepts/seven-layer-framework.md`
   - `/home/jhonny/llm-wiki/wiki/sources/source-product-led-growth-2026-7-layer-guide.md`
3. Explorar repositório: estrutura, rotas, componentes, APIs, handlers, templates, copy, analytics, feature flags, pricing, auth flows
4. Gerar `PLG_ANALYSIS.md` seguindo estritamente o template

## Workflow

### Fase 1 — Coleta
Varrer repositório por evidências em cada layer:
- Estrutura de diretórios, package.json, dependências
- Rotas, páginas, componentes, templates
- APIs, handlers, middleware, serviços
- Auth flows, onboarding flows
- Pricing, planos, paywalls, feature gates
- Landing pages, SEO config, meta tags
- Analytics, eventos, feature flags
- Copy, textos, empty states, tooltips
- Convites, sharing, colaboração, workspaces
- AI features, automações

### Fase 2 — Análise por layer
Para cada uma das 7 layers, responder perguntas diagnósticas + listar evidências + identificar problemas + sugerir oportunidades + atribuir nível de maturidade.
Seguir estritamente [ANALYSIS_TEMPLATE.md](ANALYSIS_TEMPLATE.md).

### Fase 3 — Vetores modernos
Analisar os 4 vetores: Personalização, Expansão Organizacional, Evolução do Freemium, AI como Infraestrutura.

### Fase 4 — Síntese
- Diagnosticar maior gargalo de crescimento
- Identificar layer mais fraca
- Apontar o que limita receita
- Selecionar Top 5 melhorias (impacto × velocidade)
- Propor experimentos (≥1 por layer)
- Calcular notas por dimensão
- Montar roadmap (Quick Wins / Médio Prazo / Apostas Maiores)

### Fase 5 — Saída
Gerar `PLG_ANALYSIS.md` na raiz do repositório com o formato definido no template.

## Regras

- **Seja direto, crítico e prático** — evite teoria genérica
- **Foque em crescimento e produto** — não faça análise genérica de engenharia
- **Se algo não estiver explícito no código, faça suposições explícitas** — sinalize como hipótese e justifique
- **Priorize insights acionáveis** — cada recomendação deve ter: o que fazer, por que importa, impacto esperado
- **Explicite dependências entre layers** — se GTM está quebrada, monetização não tem volume
- **Seja específico ao domínio detectado** — não copie exemplos genéricos de Canva/Slack sem adaptar
- **Não invente features sem justificar no contexto do produto**

## Reference files

- [ANALYSIS_TEMPLATE.md](ANALYSIS_TEMPLATE.md) — Template completo do relatório com estrutura obrigatória
- `/home/jhonny/llm-wiki/wiki/concepts/product-led-growth.md` — Definição PLG e 7 layers
- `/home/jhonny/llm-wiki/wiki/concepts/seven-layer-framework.md` — Detalhamento das camadas
- `/home/jhonny/llm-wiki/wiki/sources/source-product-led-growth-2026-7-layer-guide.md` — Fonte original do framework
