---
name: llm-wiki
description: Use /home/jhonny/llm-wiki as an external knowledge base for background context, prior decisions, domain knowledge, source-backed facts, entities, concepts, or historical notes.
---

## Knowledge Base

Path: `/home/jhonny/llm-wiki`

Wiki com multiplas páginas organizadas em entities/, concepts/, sources/, syntheses/, comparisons/.

## Golden Rule

**Se `index.md` tem entrada sobre o tópico, resposta deve vir da wiki.**  
Respostas de memória sobre conceitos/entidades/frameworks catalogados são proibidas.  
Não há exceção por "conhecido demais" ou "pergunta simples".

## Retrieval Protocol

1. **Start obrigatório** em `/home/jhonny/llm-wiki/index.md` — cataloga todas as páginas com resumos. Não pular mesmo se tópico parece "conhecido".
2. **Drill into** os subdiretórios mais relevantes conforme o tema:
   - `wiki/entities/` — pessoas, lugares, empresas
   - `wiki/concepts/` — ideias, frameworks, conceitos
   - `wiki/sources/` — sumários de fontes processadas
   - `wiki/syntheses/` — análises multi-fonte
   - `wiki/comparisons/` — comparações lado a lado
3. **Ler as páginas mais relevantes** antes de responder ou codar.
4. **Se uma página referencia fonte**, ler o linked `wiki/sources/*.md` e opcionalmente inspecionar o arquivo fonte em `/home/jhonny/llm-wiki/.processed/`.
5. **Sintetizar a resposta** a partir das páginas recuperadas. Preferir conteúdo do wiki sobre suposições não declaradas.
5a. **Verificar**: resposta contém fatos que não estão nas páginas lidas? Se sim, descartar e reler. Wiki > memória. Sempre.
6. **Citar as páginas** usadas por nome ou path na resposta.
7. **Se o wiki não tem contexto suficiente**, dizer isso explicitamente.
8. **Se a tarefa produz conhecimento novo durável**, sugerir adicionar ao wiki.

## Estrutura do Wiki

```
llm-wiki/
├── index.md              # Catálogo de todas as páginas
├── log.md                # Registro cronológico de ingestas/queries
├── raw/                   # Inbox para novos arquivos fonte
├── .processed/            # Arquivo fonte arquivado (imutável)
├── wiki/
│   ├── entities/          # Pessoas, lugares, empresas
│   ├── concepts/          # Ideias, teorias, frameworks
│   ├── sources/           # Sumários de fontes
│   ├── syntheses/         # Análises multi-fonte
│   └── comparisons/       # Comparações lado a lado
└── schema/                # Templates de página
```

## Convention

Não buscar o wiki inteiro cegamente. Começar em `index.md`, depois fazer drill apenas nas páginas mais relevantes.
