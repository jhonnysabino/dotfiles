---
name: grokking-refactor
description: Implement, refactor, and review code using Grokking Simplicity's functional thinking — actions/calculations/data taxonomy, stratified design, copy-on-write, defensive copying, timeline diagrams, and first-class abstractions. Use when user mentions functional refactoring, code immutability, reducing side effects, taming async bugs, or any Grokking Simplicity technique.
---

# Grokking Refactor

Apply Eric Normand's *Grokking Simplicity* techniques to write, refactor, or review code.

Always start by classifying code into the **three categories**. This drives every technique below.

## Core Workflows

### Implement new code

1. **Classify** — For each function, decide: Action, Calculation, or Data?
2. **Name by category** — Prefix `action_` for actions, `calc_` for calculations. Makes category visible at call site.
3. **Push calculations down** — Extract pure logic into calculations. Keep actions at boundaries.
4. **Pass data explicitly** — Calculations never read globals, files, or env. Everything comes as arguments.
5. **Design layers** — Group functions by level of abstraction (REFERENCE.md: stratified design).
6. **Review timeline** — If async, sketch timelines to check for race conditions.

### Refactor existing code

```
For each code smell → pick the matching FP refactoring:
```

| Smell | Refactoring | Where |
|---|---|---|
| Implicit argument in fn name | Express Implicit Argument | REFERENCE.md |
| Function does too much | Replace Body with Callback | REFERENCE.md |
| Global variable dependency | Pass as explicit argument | Concepts: actions-calculations-data |
| Nested loop | Replace with map/filter/reduce | REFERENCE.md |
| Read-write confusion | Split or copy-on-write | REFERENCE.md |
| Mutable state leaking | Copy-on-write discipline | REFERENCE.md |
| Untrusted code mutating data | Defensive copying | REFERENCE.md |

### Review pull requests

1. **Category check**: Is every function correctly categorized? Actions should be explicit and rare.
2. **Naming check**: Do action names start with `action_`? Do calculation names start with `calc_`? Category should be visible from the name.
3. **Data flow check**: Do calculations read globals/files/env? They shouldn't — all inputs as arguments.
4. **Layer check**: Draw call graph. Are business rules mixing with array internals?
5. **Immutability check**: Any in-place mutation that should be copy-on-write?
6. **Timeline check**: Can async operations race? Use timeline diagrams.
7. **Primitive obsession**: Do function signatures take the right abstractions?

## Core Mindset

```
Prefer:  Data > Calculation > Action
Rule:    Push complexity to boundaries (actions). Keep core logic pure.
Test:    Calculations need no mocks. Actions need integration tests.
Async:   Every app is a distributed system. Use timeline diagrams.
```

## Code Layout Convention

Organize files into labeled sections. Example structure:

```
# ===== Configuration (data) =====
# Constants, paths, env vars — inert facts

# ===== Actions (action_*) =====
# I/O, side effects, external calls
# Each: explicitly documented with its side effect

# ===== Calculations (calc_*) =====
# Pure functions. Same input → same output
# Never read globals, files, or env

# ===== Orchestration =====
# Thin composition: call actions → pass data to calculations → call actions
```

## Quick Reference

- [REFERENCE.md](REFERENCE.md) — Full technique catalog with code examples

REFERENCE.md covers:
- Actions/Calculations/Data classification
- Naming conventions with before/after
- Refactoring patterns with before/after
- Copy-on-write & defensive copying
- Stratified design (4 patterns)
- Timeline diagram protocol
- map/filter/reduce chaining
- Functional core / imperative shell
