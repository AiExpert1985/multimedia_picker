---
description: Initialize new Obelisk project
---

**CURRENT STATE: PROJECT START**

Two-phase process: Discovery (discussion) → Initialization (file creation).

---

# PHASE 1: DISCOVERY

Understand the project through discussion. **No files created yet.**

---

## Rules

- Ask questions only about the project/system
- Do NOT propose solutions, designs, or code
- Do NOT assume missing information — surface it explicitly
- Identify **contract candidates** and **tech-memory candidates**

---

## Question Focus

**Ask about:**
- System identity (what it is / is not)
- Core invariants (rules that must always hold)
- Global constraints (apply to all future work)
- Safety, data correctness, or irreversible risk
- Technology boundaries (target platforms, languages)

**Skip:**
- Rare edge cases
- Speculative future features
- Anything deferrable to task-level work

---

## Discovery Flow

1. **Open:** "Please describe the system you want to build. What problem does it solve, who uses it, and what constraints matter?"

2. **Clarify:** Ask follow-up questions until core understanding is clear

3. **Summarize:** Present summary for confirmation

---

## Summary Format

```markdown
**System Identity:**
- What it is: [description]
- What it is NOT: [exclusions]
- Users: [who uses it]

**Contract Candidates:**
- Core: [project-wide rules]
- [Feature A]: [feature-specific rules]
- [Feature B]: [feature-specific rules]

**Tech-Memory Candidates:**
- [Technical decision: why]

**Safety Concerns:** [if any]
**Explicit Non-Goals:** [what won't be done]
**Open Questions:** [unresolved items]
```

---

## Discovery Exit

After user confirms summary:

> "Summary confirmed. Reply **'initialize'** to create project files."

- **On 'initialize':** → Proceed to Phase 2 (INITIALIZATION)
- **On corrections:** → Update summary, confirm again

---

# PHASE 2: INITIALIZATION

Extract and persist project truth. **Non-interactive, non-creative.**

---

## Preflight

Check `/obelisk/state/` directory.

- **If files exist:** → "⚠️ Project files already exist. Overwrite? [yes/no]" → Wait
- **If empty or doesn't exist:** → Proceed

---

## Rules

- Use ONLY information explicitly established in discussion
- Do NOT invent, infer, or strengthen intent
- Be minimal — over-specification is failure
- List unresolved items explicitly

---

## Required Outputs

### 1. Contract Files (`/obelisk/state/`)

**`core.domain.md`** — Project-wide invariants:
- System Identity
- Global Business Rules
- Explicit Non-Goals
- Safety-Critical Rules
- Open Questions

**`[feature].domain.md`** — Per feature identified in discovery:
- Feature-specific invariants only
- Create only for features with distinct rules

---

### 2. `/obelisk/state/tech-memory.md`

Technical decisions not inferable from code:
- Stack choices and rationale
- Non-obvious architectural decisions
- Build/run/test commands
- Constraints not visible in code

---

### 3. `/obelisk/tasks/project-backlog.md`

```markdown
# Project Backlog

## System Requirements
[Implementation details and specs from discussion]

## Tasks
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3] (?)  ← uncertain items marked

---
> This file is for human reference only and has NO authority.
> Only contracts, frozen tasks, and code define system behavior.
```

---

## Verification

Confirm all files created:
- `/obelisk/state/core.domain.md`
- `/obelisk/state/tech-memory.md`
- `/obelisk/tasks/project-backlog.md`

---

## Output

> "✅ PROJECT INITIALIZED
>
> Created:
> - `core.domain.md` + [N] feature contracts
> - `tech-memory.md`
> - `project-backlog.md`
>
> Next: `/new-task` — Start building the first feature or `/suggest-task` — AI suggests tasks based on the project knowledge"