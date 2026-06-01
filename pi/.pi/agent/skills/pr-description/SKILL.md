---
name: pr-description
description: Generate pull request descriptions from unpushed commits. Reads git log, changed files, and diff stats, then crafts a structured PR description with O que foi feito, Como foi feito, Testes, and Extras sections. Use when user asks to create PR description, generate PR, describe changes for a pull request, or summarise unpushed commits.
---

# PR Description

Gera descricao de PR a partir dos commits nao pushados.

## Workflow

1. `node scripts/unpushed-commits.js` - extrai commits, arquivos, diff stats
2. Analisa saida JSON e gera descricao com 4 secoes obrigatorias:

### Secoes da descricao

**O que foi feito** - resumo executivo. O que o PR entrega de valor. Uma frase forte.

**Como foi feito** - abordagem tecnica. Padroes usados, arquivos tocados, decisoes.

**Testes** - como testar. Testes manuais, comando pra rodar, cenario de sucesso.

**Extras** - qualquer contexto extra: links pra issue, breaking changes, TODOs, prints.

### Regras de tom

- Linguagem fluida e natural, como um dev explicando pra outro dev
- Uma frase por linha
- Evitar jargao excessivo
- Seeder / Service / Controller / DTO manter maiusculo (nomes de classe)
- Adaptar granularidade ao numero de commits: 1 commit = descricao direta, varios = agrupar por tema

## Casos especiais

| Situacao | Acao |
|---|---|
| Sem commits nao pushados | Avisar e sugerir criar branch |
| Branch default | Avisar e pedir criar branch |
| Muitos commits (>5) | Agrupar por Padrao/Feature/Fix em "O que foi feito" |
| Breaking changes | Destacar em "Extras" com icone ⚠️ |
| Sem diff (merge commit) | Usar mensagens dos commits como fonte |

## Exemplo de saida

```
node scripts/unpushed-commits.js
```

```json
{
  "currentBranch": "feat/pagamento-pix",
  "defaultBranch": "main",
  "commits": [
    { "hash": "abc123", "message": "feat(payment): add PIX payment method" }
  ],
  "files": ["src/payment/pix.ts", "src/payment/types.ts"],
  "diffStats": "2 files changed, 85 insertions(+), 3 deletions(-)"
}
```

Gerar entao:

**O que foi feito**  
Adicionamos PIX como novo metodo de pagamento, permitindo que clientes paguem por QR Code.

**Como foi feito**  
Criamos `src/payment/pix.ts` com logica de geracao de QR Code e confirmacao. Atualizamos `src/payment/types.ts` com os novos tipos. Segue mesmo padrao dos metodos existentes (boleto, cartao).

**Testes**  
Rodar `npm run test -- --grep PIX`. Verificar: criacao de cobranca, expiracao de QR Code, webhook de confirmacao.

**Extras**  
Depende da API do banco X. Precisa configurar `PIX_API_KEY` no .env.
