# PLG Analysis Template — Estrutura Obrigatória

> Use este template para gerar `PLG_ANALYSIS.md`. Siga estritamente esta estrutura.
> Consulte também: `/home/jhonny/llm-wiki/wiki/concepts/seven-layer-framework.md`

---

# 📊 PLG Analysis Report

## 🧠 Executive Summary

Resumo em 3-4 parágrafos:
- Qual o estado geral de maturidade PLG do produto
- Qual o maior gargalo de crescimento detectado
- Quais as 2-3 alavancas mais promissoras
- Nota geral de maturidade PLG (0-10) com justificativa curta

---

## 🚨 Main Bottlenecks

Top 3 gargalos que limitam crescimento. Para cada um:
- **O que é** — descrição do gargalo
- **Layer afetada** — qual camada impacta
- **Impacto** — o que está custando em termos de aquisição, conversão, retenção ou receita
- **Urgência** — por que resolver agora

---

## 🧱 7 Layers Analysis

Para cada layer, responda as perguntas diagnósticas + evidências no código + oportunidades.

### Layer 1 — Go-To-Market

**Perguntas diagnósticas:**
- O produto permite aquisição orgânica?
- Existe alguma forma de usar o produto sem login?
- Existe potencial de SEO / páginas públicas / templates?
- Está mais próximo de modelo antigo (Slack) ou moderno (Canva)?

**Evidências no repositório:**
Liste arquivos, rotas, componentes, meta tags, landing pages, SEO config, páginas públicas, template galleries.

**Problemas e fricções:**
- Onde a aquisição está travada?
- Loginwall prematuro?
- Zero páginas indexáveis?
- Sem SEO/AEO/GEO?

**Oportunidades:**
Sugestões concretas alinhadas ao domínio do produto.

**Nível de maturidade:** Baixo / Médio-Baixo / Médio / Médio-Alto / Alto

---

### Layer 2 — Information for Decision

**Perguntas diagnósticas:**
- O valor do produto é claro rapidamente?
- Existe segmentação de usuários?
- O usuário consegue visualizar o resultado antes de usar?
- Existem templates ou exemplos?

**Evidências no repositório:**
Pricing pages, planos, comparações, cases, templates, landing pages de funcionalidades, hero copy.

**Problemas e fricções:**
- Usuário não consegue se auto-segmentar?
- Informação insuficiente para decidir?
- Visual segmentation inexistente?

**Oportunidades:**

**Nível de maturidade:** Baixo / Médio-Baixo / Médio / Médio-Alto / Alto

---

### Layer 3 — Free → Paid Conversion

**Perguntas diagnósticas:**
- Existe monetização definida?
- O produto demonstra valor antes de cobrar?
- Existem oportunidades para reverse trial?
- Existem oportunidades para billing gates contextuais?
- Onde o usuário sente necessidade de pagar?

**Evidências no repositório:**
Planos, paywalls, trial config, feature gates, billing integration, limites de uso, mensagens de upgrade.

**Problemas e fricções:**
- Sem mecanismo de conversão?
- Trial inexistente ou mal configurado?
- Gates genéricos em vez de contextuais?
- Cartão de crédito exigido cedo demais?

**Oportunidades:**

**Nível de maturidade:** Baixo / Médio-Baixo / Médio / Médio-Alto / Alto

---

### Layer 4 — Activation

**Perguntas diagnósticas:**
- O usuário chega rápido ao "aha moment"?
- O produto faz algo automaticamente pelo usuário?
- Existe onboarding inteligente?
- Existe uso de AI para acelerar valor?

**Evidências no repositório:**
Fluxos de onboarding, checklists, welcome states, empty states, tooltips, templates iniciais, exemplos pré-preenchidos, AI features.

**Problemas e fricções:**
- Onboarding longo ou confuso?
- Usuário precisa fazer muito trabalho antes de ver valor?
- Sem personalização por persona?
- Aha moment não definido ou inalcançável?

**Oportunidades:**

**Nível de maturidade:** Baixo / Médio-Baixo / Médio / Médio-Alto / Alto

---

### Layer 5 — Retention

**Perguntas diagnósticas:**
- O produto cria dependência ou hábito?
- Existe colaboração (time) ou é individual?
- Existe efeito de rede?
- O produto é fácil de abandonar?

**Evidências no repositório:**
Notificações, emails, in-app messages, collaboration features, workspaces, teams, sharing, histórico, gamificação, streaks, dashboards.

**Problemas e fricções:**
- Produto puramente individual sem network effects?
- Sem loops de hábito?
- Churn signals não monitorados?
- Sem notificações de re-engajamento?

**Oportunidades:**

**Nível de maturidade:** Baixo / Médio-Baixo / Médio / Médio-Alto / Alto

---

### Layer 6 — Monetization

**Perguntas diagnósticas:**
- Modelo atual ou possível: seat-based, usage-based, hybrid?
- Existe um value metric claro?
- Existem múltiplas formas de gerar receita?

**Evidências no repositório:**
Planos, pricing tiers, limites, quotas, billing integration, metering, feature gating, upgrade paths.

**Problemas e fricções:**
- Pricing não alinhado a valor?
- Sem value metric clara?
- Sem múltiplos vetores de receita?
- Upgrade path confuso ou inexistente?

**Oportunidades:**

**Nível de maturidade:** Baixo / Médio-Baixo / Médio / Médio-Alto / Alto

---

### Layer 7 — Expansion

**Perguntas diagnósticas:**
- Pode expandir dentro da empresa?
- Pode atingir outros times?
- Existe upsell natural?
- Existem features que aumentam ticket?

**Evidências no repositório:**
Convites, sharing, team management, workspaces, multi-tenant, roles/permissions, referrals, viral loops.

**Problemas e fricções:**
- Sem mecanismo de convite ou compartilhamento?
- Expansão entre times impossível?
- Sem upsell path natural?

**Oportunidades:**

**Nível de maturidade:** Baixo / Médio-Baixo / Médio / Médio-Alto / Alto

---

## ⚡ Modern Vectors Analysis

### 1. Personalização
- O produto se adapta ao usuário ou é genérico?
- Existe onboarding segmentado por persona?
- Conteúdo e features mudam com base no uso?

### 2. Expansão Organizacional
- Focado em indivíduo ou empresa?
- Existe suporte a múltiplos usuários / times / workspaces?
- Path de expansão dentro da organização?

### 3. Evolução do Freemium
- Modelo moderno (reverse trial, gates contextuais) ou básico (free tier simples)?
- O produto demonstra valor premium antes de pedir pagamento?
- Existem múltiplos pontos de conversão contextual?

### 4. AI como Infraestrutura
- AI está no core do produto?
- O produto faz o trabalho pelo usuário?
- AI reduz tempo para valor?
- AI cria lock-in composto?

---

## 🔍 Diagnosis

### Qual o maior gargalo de crescimento?
Resposta direta com evidências do código.

### Qual layer está mais fraca?
Layer + justificativa + evidências.

### O que está limitando receita?
Fator principal + como resolver.

### Dependências entre layers
Quais layers bloqueiam outras? Ex: GTM quebrada → sem volume para testar monetização.

---

## 🚀 Top 5 Improvements

Para cada uma das 5 mudanças mais importantes:

1. **O que fazer** — ação concreta e específica
2. **Por que importa** — problema que resolve + impacto no negócio
3. **Impacto esperado** — métrica afetada + magnitude estimada
4. **Layer relacionada** — qual camada do framework
5. **Complexidade** — Baixa / Média / Alta
6. **Dependências** — o que precisa existir antes

Priorize por: impacto × velocidade de execução.

---

## 🧪 Experiments

Pelo menos 1 experimento por layer. Para cada um:

- **Layer:** qual camada
- **Hipótese:** o que acreditamos que vai acontecer
- **Mudança proposta:** o que implementar
- **Métrica principal:** o que medir para validar
- **Métrica secundária:** métrica de guarda (não pode piorar)
- **Resultado esperado:** magnitude e direção
- **Tempo estimado:** dias/semanas para ter dados
- **Complexidade:** Baixa / Média / Alta

Priorize experimentos: baratos, rápidos, reversíveis, mensuráveis.

---

## 📈 Final Score

| Dimensão | Nota (0-10) | Justificativa curta |
|----------|-------------|---------------------|
| Go-To-Market | | |
| Information for Decision | | |
| Free→Paid Conversion | | |
| Activation | | |
| Retention | | |
| Monetization | | |
| Expansion | | |
| Personalização | | |
| Expansão Organizacional | | |
| Freemium Evolution | | |
| AI Infrastructure | | |
| **Média PLG** | | |

### Priorização

| Prioridade | Layer | Ação | Por que |
|------------|-------|------|---------|
| 1 (agora) | | | |
| 2 | | | |
| 3 | | | |

---

## Roadmap Consolidado

### ⚡ Quick Wins
(Baixo esforço, alto impacto, validáveis em dias)

| Item | Layer | Objetivo | Impacto | Complexidade |
|------|-------|----------|---------|--------------|
| | | | | |

### 🏗️ Médio Prazo
(Estruturais, semanas, desbloqueadores)

| Item | Layer | Objetivo | Impacto | Complexidade | Dependências |
|------|-------|----------|---------|--------------|--------------|
| | | | | | |

### 🎯 Apostas Maiores
(Maior potencial, mais risco, meses)

| Item | Layer | Objetivo | Impacto | Complexidade | Dependências |
|------|-------|----------|---------|--------------|--------------|
| | | | | | |
