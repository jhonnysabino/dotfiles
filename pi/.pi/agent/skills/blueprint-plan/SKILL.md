---
name: blueprint-plan
description: Generate copy-paste-ready implementation plans with real code, real data formats, and phased verification checkpoints. Use when user says "create a plan", "blueprint", "implementation plan", or asks for a detailed technical plan before building something substantial. Not for trivial tasks.
---

# Blueprint Plan Generator

Generate plans so detailed that any developer (or LLM) can execute them by copy-pasting, without guessing.

## Core Principle

**The plan IS the implementation.** Every file, every type, every function written out. No hand-waving. No "implement X". Show the actual code.

---

## Plan Structure (follow this order)

### 1. Header

```markdown
# Plano: <Title>

## Goal
<One sentence. Technology stack. Key constraints.>
```

### 2. Prerequisites

List everything needed before starting. Include install commands and verification commands.

```markdown
## Pré-requisitos

### <Tool> <Version>+
\`\`\`bash
# Check if installed
<command>
# Install if missing
<install command>
\`\`\`
```

### 3. Directory Structure

ASCII tree of ALL files that will be created. Annotate each file with one-line purpose.

```markdown
## Estrutura de diretórios

\`\`\`
project/
├── existing/           # (não mexer)
├── new-dir/
│   ├── file1.go        # propósito em uma linha
│   └── file2.go        # propósito em uma linha
\`\`\`
```

### 4. Data Formats (if reading existing data)

Show REAL examples of every file format the implementation must consume. Not invented — sampled from the actual project. This is the bridge between existing system and new code.

```markdown
## Formatos de arquivo que a WebUI precisa ler

**path/to/file.json:**
\`\`\`json
{actual content from project}
\`\`\`
```

### 5. Concept Primer (if using unfamiliar tech)

Brief explanation of key technologies/libraries the implementer might not know. Code snippets showing usage patterns. NOT marketing copy — just enough to be productive.

### 6. Routes / API / Interface Map

List all endpoints, functions, or interfaces upfront. The full surface area of what will be built.

```markdown
## Rotas HTTP

\`\`\`
GET  /path              Descrição
POST /path              Descrição
\`\`\`
```

### 7. Implementation Phases

Each phase:

#### Phase structure

```markdown
### Fase N: <Name>

**Objetivo:** <One sentence. What "done" looks like.>

#### N.1 Sub-task
\`\`\`go
// full/path/file.go
package ...
<complete file content>
\`\`\`

- [ ] Criar `path/file.go`
- [ ] Criar `path/file2.go`
- [ ] `go build ./...` compila

**Verificar:** <Concrete manual test. What to see/expect.>
```

#### Phase rules

1. **Show full file contents.** Not snippets. Not pseudocode. The actual `package`, imports, types, functions.
2. **Each phase is independently verifiable.** Must compile or run after each phase.
3. **Phases build linearly.** Phase N+1 depends only on phases ≤N.
4. **Checklist at end of each phase.** Every file created gets a `- [ ]`.
5. **Verification step at end of each phase.** Manual test or build command.
6. **Phase 1 is always "Hello World".** Get something running immediately. Scaffold, layout, one route, render.
7. **Types phase before IO phase.** Pure data structures first, then reading/writing.
8. **Read phase before write phase.** GET handlers before POST handlers.

### 8. Final Checklist

Aggregate all `- [ ]` items across all phases at the end for easy tracking.

### 9. How to Run

```markdown
## Como rodar

\`\`\`bash
cd <dir>
make dev
# Abre http://...
\`\`\`
```

### 10. Dependencies

List external dependencies with exact versions.

```markdown
## Dependências

\`\`\`
module <name>
go <version>

require <dep> <version>
\`\`\`
```

### 11. Notes

Non-obvious constraints, design decisions, things to watch out for.

---

## Before Writing the Plan

1. **Read the project.** `ls`, `cat package.json`/`go.mod`, understand structure.
2. **Read existing data.** Sample actual JSON/YAML files the implementation will consume. Copy them into the plan.
3. **Identify the tech stack.** What language, framework, libraries? Are they already in the project or new?
4. **Check what exists.** Don't plan to create something that already exists.
5. **Ask clarifying questions** if critical decisions are ambiguous (which DB, which framework, etc.).

## Quality Checklist for the Plan

Before delivering, verify:

- [ ] Can someone execute Phase 1 with ONLY the plan? No external docs needed?
- [ ] Does every code block have the full file path as comment?
- [ ] Are data formats real samples (not invented)?
- [ ] Does each phase have a verification step?
- [ ] Is Phase 1 a working "hello world"?
- [ ] Are types defined before IO code?
- [ ] Are reads before writes?
- [ ] Total checkboxes = total files/actions to create?
- [ ] No "implement X" without showing the code for X?

## Anti-patterns to Avoid

- ❌ "Create a service layer" → ✅ Show the actual service files with full code
- ❌ "Add CRUD endpoints" → ✅ List each endpoint and show handler code
- ❌ "Follow the existing pattern" → ✅ Show what pattern, with example code
- ❌ "Add appropriate error handling" → ✅ Show the error handling in the code
- ❌ "Configure the build system" → ✅ Show the Makefile/package.json/go.mod
- ❌ Giant monolithic phase → ✅ Break into small independently-verifiable phases
