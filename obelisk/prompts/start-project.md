---
description: start new obelisk project
---

**CURRENT STATE: PROJECT DISCOVERY**

Your task is to understand a software project through discussion so it can later be formalized into:

- **Contracts** — domain/business rules that must always hold (invariants)
- **Tech Memory** — technical decisions that cannot be reliably inferred from code

This phase is **discussion only**.

NO files are created.  
NO tasks are defined.  
NO planning or implementation occurs.

Nothing discussed here is authoritative yet.

---

## Rules

- Ask questions only about the project/system
- Do NOT propose solutions, designs, or code
- Do NOT make decisions for the user
- Do NOT assume missing information — surface it explicitly
- Identify and flag **contract candidates** and **tech-memory candidates**
- Do NOT write, freeze, or structure tasks

---

## Question Selection

Ask ONLY high-impact questions affecting:
- System identity (what it is / is not)
- Core invariants (rules that must always hold)
- Global constraints (apply to all future work)
- Safety, data correctness, or irreversible risk

Skip:
- Rare edge cases
- Speculative future features
- Hypothetical failure modes
- Anything deferrable to task-level work

---

## Discussion Flow

### 1. Initial Understanding
- Purpose, users, scope, invariants, safety concerns

### 2. Refinement (if needed)
- Clarify ambiguities
- Resolve critical uncertainties

### 3. Summary & Confirmation
- Present summary (format below)
- User confirms or corrects

---

## How to Begin

> "Please describe the system you want to build. What problem does it solve, who uses it, and what constraints matter?"

---

## Summary Format
```
**System Identity:**
- What it is: [description]
- What it is NOT: [exclusions]
- Users: [who uses it]

**Contract Candidates:**
- [Business rule 1]
- [Business rule 2]

**Tech-Memory Candidates:**
- [Technical decision: why]

**Safety Concerns:** [if any]
**Explicit Non-Goals:** [what won't be done]
**Open Questions:** [unresolved items]
```

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

### 1. `/obelisk/state/*.domain.md`

Business invariants — what must remain true during execution.

**Include:**
- System Identity (is / is not / for whom / core promise)
- Business Invariants (rules that must always hold)
- Explicit Non-Goals
- Safety-Critical Rules (if any)
- Open Questions (unresolved ambiguities)

**Exclude:** UI/UX, architecture, workflows, implementation details

**Rule:** Reflect explicitly agreed intent only — do NOT generalize or strengthen.

note, there should be multiple *.domain.md files, one core.domain.md for project wide 
Business invariants, and one <feature>.domain.md file per feature, where it contains
business invariants specific for the feature

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

