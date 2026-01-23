---
description: create obelisk project files
---


---

**CURRENT STATE: PROJECT INITIALIZATION**

Extract and persist project truth from the completed discovery discussion.

This phase is **non-interactive and non-creative**.

---

## Rules

- Use ONLY information explicitly established in the discussion
- Do NOT invent, infer, generalize, or strengthen intent
- Do NOT perform task-level planning or execution
- Be minimal — over-specification is failure
- List unresolved items explicitly
- Do NOT ask questions

---

## Required Outputs

Create exactly these files:

---

### 1. `/obelisk/state/<project>.domain.md`

Business invariants — what must remain true during execution.

**Include:**
- System Identity (is / is not / for whom / core promise)
- Business Invariants (rules that must always hold)
- Explicit Non-Goals
- Safety-Critical Rules (if any)
- Open Questions (unresolved ambiguities)

**Exclude:** UI/UX, architecture, workflows, implementation details

**Rule:** Reflect explicitly agreed intent only — do NOT generalize or strengthen.

---

### 2. `/obelisk/state/tech-memory.md`

Technical decisions that cannot be reliably inferred from code.

**Include:**
- Stack choices and rationale (why)
- Non-obvious architectural decisions
- Required commands (build / run / test)
- Constraints not visible from code

**Exclude:** Tasks, plans, speculative decisions, generic best practices

---

### 3. `/obelisk/tasks/project-backlog.md`

System requirements and follow-up work for humans.

**Structure:**
1. System Requirements — implementation details and specs
2. Remaining Tasks — follow-up items

**Rules:**
- Extract only what was explicitly stated or clearly implied
- Mark uncertain items with `(?)`
- Order by expected execution sequence
- May include UI notes, workflows, validation rules, examples, or testing notes if discussed

**Required Footer:**
> "This file is for human reference only and has NO authority.  
> Only contracts, frozen tasks, and code define system behavior."

---

## Completion

After creating all files, output:

> "Framework initialization complete. Close this session and start fresh for task work."
