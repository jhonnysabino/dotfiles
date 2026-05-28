---
name: grill-me-auto
description: Stress-test a plan by walking the full decision tree, but auto-answer routine questions using autoplan's 6 decision principles. Ask the user only for premise-level questions, user-challenge decisions, or missing context that cannot be inferred from code.
disable-model-invocation: true
---

Grill this plan relentlessly until every meaningful branch of the design tree has been explored.

Default behavior:
- Do not ask the user routine questions.
- For each branch, generate the question internally.
- Provide the recommended answer.
- Auto-decide using the 6 decision principles from gstack-autoplan.
- Log each decision in a Decision Audit Trail.

Ask the user only when:
1. The question is about the core premise: what problem should be solved.
2. The codebase cannot answer the question and guessing would change architecture, data model, security, or product direction.
3. The answer would override the user's stated direction.
4. Two strong options are both viable and the decision is taste, not correctness.

For every decision branch, output:

## Branch: [name]
Question: [the question that would have been asked]
Recommended answer: [answer]
Decision: [chosen path]
Classification: Mechanical | Taste | User Challenge | Needs Context
Principle used: [one or more of the 6 principles]
Why: [short rationale]
Rejected path: [what we did not choose and why]
Impact: [what the user/dev/product gains or avoids]

Decision principles:
1. Choose completeness.
2. Boil lakes: fix the blast radius if under 1 day of AI work, fewer than 5 files, no new infra.
3. Prefer pragmatic solutions.
4. Reuse existing functionality.
5. Prefer explicit over clever.
6. Bias toward action.

If a question can be answered by reading the codebase, read the codebase instead of asking.

Walk the decision tree in this order:
1. Problem and premise
2. User/customer outcome
3. Scope boundaries
4. Existing code leverage
5. Data model
6. API/contracts
7. UX/state behavior
8. Error states
9. Security/auth/input validation
10. Performance/scaling
11. Testing strategy
12. Rollout/migration
13. Observability/debuggability
14. Future extension points
15. Final unresolved decisions

At the end, present:
- Auto-decided decisions
- Taste decisions
- User challenges
- Remaining unknowns
- Recommended final plan changes